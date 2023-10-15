//
//  JPFilledButtonView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import SwiftUI

struct JPFilledButtonView: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: { action() }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.mainRed)
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.white)
            }
        }
        .frame(height: 48)
    }
}

// MARK: - Preview
#Preview {
    JPFilledButtonView(title: "Analyze", action: {})
}
