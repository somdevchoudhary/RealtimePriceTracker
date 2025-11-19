//
//  SplashView.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 19/11/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 25) {
                Spacer()
                Image("multibankgroup")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 20)
                Text("Realtime\nPrice Tracker")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.primary)
                Spacer()
                Text("© MultiBank Group")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)
            }
            .padding()
        }
    }
}

#Preview {
    SplashView()
}
