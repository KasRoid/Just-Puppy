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
    @State private var showingAlert = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                List {
                    item(viewStore: viewStore)
                }
                .scrollDisabled(true)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

// MARK: - UI
extension SettingsView {
    
    private func item(viewStore: ViewStoreOf<SettingsReducer>) -> some View {
        Button(action: { showingAlert = true }) {
            Text ("Delete all analyses")
                .foregroundStyle(Color.red)
        }
        .alert("Are you sure you want to delete all analyses?", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete All", role: .destructive) { 
                viewStore.send(.deleteAll)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView(store: .init(initialState: .init(), reducer: { SettingsReducer() }))
}
