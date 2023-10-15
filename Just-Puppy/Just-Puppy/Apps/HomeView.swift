//
//  HomeView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/1/23.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    
    let store: StoreOf<MainReducer>
    
    var body: some View {
        mainView
    }
}

// MARK: - UI
extension HomeView {
    
    private var mainView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                Group {
                    if viewStore.histories.isEmpty {
                        noDataView
                    } else {
                        listView(viewStore)
                    }
                }
                .navigationTitle("Home")
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
    
    private func listView(_ viewStore: ViewStoreOf<MainReducer>) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewStore.histories, id: \.self) { history in
                    Text(history)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView(store: .init(initialState: MainReducer.State(),
                          reducer: { MainReducer() })
    )
}
