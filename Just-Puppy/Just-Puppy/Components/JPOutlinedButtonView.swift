//
//  JPOutlinedButtonView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import SwiftUI

struct JPOutlinedButtonView: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: { action() }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.mainRed, lineWidth: 1)
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.mainRed)
            }
        }
        .frame(height: 48)
    }
}

// MARK: - Preview
#Preview {
    JPOutlinedButtonView(title: "Analyze", action: {})
}
