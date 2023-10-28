//
//  JPNavigationBackButtonView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import SwiftUI

struct JPNavigationBackButtonView: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: { action() }) {
            Image(systemName: "arrowshape.backward.fill")
                .resizable()
                .foregroundStyle(Color.mainRed)
                .frame(width: 24, height: 24)
        }
        .frame(width: 40, height: 40)
    }
}

// MARK: - Preview
#Preview {
    JPNavigationBackButtonView(action: {})
}
