//
//  MainView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/1/23.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    
    let store: StoreOf<MainReducer>
    
    var body: some View {
        mainView
    }
}

// MARK: - UI
extension MainView {
    
    private var mainView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                Group {
                    if viewStore.histories.isEmpty {
                        noDataView
                    } else {
                        ScrollView {
                            listView(viewStore)
                        }
                    }
                }
                .navigationTitle("Analysis History")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private var noDataView: some View {
        VStack {
            Spacer()
            Text("No Data")
            Spacer()
        }
    }
    
    private func listView(_ viewStore: ViewStore<MainReducer.State, MainReducer.Action>) -> some View {
        VStack(spacing: 0) {
            ForEach(viewStore.histories, id: \.self) { history in
                Text(history)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MainView(store: .init(initialState: MainReducer.State(),
                          reducer: { MainReducer() })
    )
}
