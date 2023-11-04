//
//  SettingsView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/4/23.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    
    let store: StoreOf<SettingsReducer>
    
    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView(store: .init(initialState: .init(), reducer: { SettingsReducer() }))
}
