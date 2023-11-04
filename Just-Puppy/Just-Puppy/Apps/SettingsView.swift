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
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                List {
                    Text ("Delete all analyses")
                        .foregroundStyle(Color.red)
                }
                .scrollDisabled(true)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    SettingsView(store: .init(initialState: .init(), reducer: { SettingsReducer() }))
}
