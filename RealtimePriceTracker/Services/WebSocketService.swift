//
//  WebSocketService.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import Foundation
import Combine

/// WebSocketServiceType
protocol WebSocketServiceType {
    var messages: AnyPublisher<PriceUpdate, Never> { get }
    func connect()
    func disconnect()
    func send(_ message: PriceUpdate)
    var isConnected: Bool { get }
}

/// WebSocketService
final class WebSocketService: WebSocketServiceType {
    
    // MARK: - Public stream
    
    var messages: AnyPublisher<PriceUpdate, Never> {
        messageSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private properties
    
    private let url: URL?
    private let session: URLSession
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var listenTask: Task<Void, Never>?
    private let messageSubject = PassthroughSubject<PriceUpdate, Never>()
    
    // MARK: - Computed connection state
    
    var isConnected: Bool {
        guard let task = webSocketTask else { return false }
        return task.state == .running && task.closeCode == .invalid
    }
    
    // MARK: - Init
    
    init(
        url: URL? = URL(string: "wss://ws.postman-echo.com/raw"),
        session: URLSession = .shared
    ) {
        self.url = url
        self.session = session
    }
        
    // MARK: Connect
    func connect() {
        // Avoid opening multiple sockets
        guard webSocketTask == nil, let url = url else { return }
        
        let task = session.webSocketTask(with: url)
        webSocketTask = task
        task.resume()
        
        // Start async receive loop
        listenTask = Task { [weak self] in
            await self?.listenLoop()
        }
    }
    
    // MARK: Disconnect
    func disconnect() {
        // Stop receive loop
        listenTask?.cancel()
        listenTask = nil
        
        // Close WebSocket
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
    
    func send(_ message: PriceUpdate) {
        guard let task = webSocketTask else { return }
        guard task.state == .running, task.closeCode == .invalid else { return }
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let data = try encoder.encode(message)
                try await task.send(.data(data))
            } catch {
                task.cancel(with: .goingAway, reason: nil)
                self.webSocketTask = nil
            }
        }
    }
    
    // MARK: - Receive loop (async/await)
    
    private func listenLoop() async {
        guard let task = webSocketTask else { return }
        
        while !Task.isCancelled {
            do {
                let message = try await task.receive()
                handle(message)
            } catch {
                if Task.isCancelled { break }
                
                // Treat any receive error as a dead socket
                task.cancel(with: .goingAway, reason: nil)
                self.webSocketTask = nil
                break
            }
        }
    }
    
    private func handle(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .data(let data):
            decodeAndPublish(data)
            
        case .string(let string):
            if let data = string.data(using: .utf8) {
                decodeAndPublish(data)
            }
            
        @unknown default:
            break
        }
    }
    
    private func decodeAndPublish(_ data: Data) {
        guard let update = try? decoder.decode(PriceUpdate.self, from: data) else {
            return
        }
        messageSubject.send(update)
    }
}

