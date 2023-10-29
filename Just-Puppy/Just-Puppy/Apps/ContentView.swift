//
//  ContentView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/3/23.
//

import ComposableArchitecture
import SwiftUI
import OrderedCollections

struct ContentView: View {
    
    let store: StoreOf<ContentReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewState in
            if viewState.initialized {
                mainView(with: viewState)
            } else {
                SplashView(initialized: viewState.binding(get: { $0.initialized },
                                                          send: ContentReducer.Action.initialize))
            }
        }
    }
}

// MARK: - UI
extension ContentView {
    
    private func mainView(with viewState: ViewStore<ContentReducer.State, ContentReducer.Action>) -> some View {
        tabView(with: viewState)
            .fullScreenCover(isPresented: viewState.binding(get: { $0.isCameraPresented },
                                                            send: ContentReducer.Action.hideCamera)) {
                CameraView()
                    .ignoresSafeArea()
                    .onAppear { viewState.send(.hideCameraLoading) }
            }
    }
    
    private func tabView(with viewState: ViewStore<ContentReducer.State, ContentReducer.Action>) -> some View {
        JPTabView(selectedTab: viewState.binding(get: { $0.selectedTab },
                                                 send: ContentReducer.Action.select),
                  action: { viewState.send(.checkCameraAuthorization) },
                  isLoading: viewState.isCameraLoading) {
            
            homeView(with: viewState)
            favoritesView(with: viewState)
        }
    }
    
    @ViewBuilder
    private func homeView(with viewState: ViewStore<ContentReducer.State, ContentReducer.Action>) -> some View {
        let store = StoreOf<MainReducer>(initialState: .init(analyses: AnalysisManager.shared.analyses), reducer: { MainReducer() })
        HomeView(store: store)
            .tabBarItem(.home, selectedTab: viewState.binding(get: { $0.selectedTab },
                                                              send: ContentReducer.Action.select))
    }
    
    private func favoritesView(with viewState: ViewStore<ContentReducer.State, ContentReducer.Action>) -> some View {
        let analyses = OrderedSet(AnalysisManager.shared.analyses.filter(\.isFavorite))
        let store = StoreOf<FavoriteReducer>(initialState: .init(analyses: analyses), reducer: { FavoriteReducer() })
        return FavoritesView(store: store)
            .tabBarItem(.favorites, selectedTab: viewState.binding(get: { $0.selectedTab },
                                                                   send: ContentReducer.Action.select))
    }
}

// MARK: - Preview
#Preview {
    ContentView(store: .init(initialState: .init(), reducer: { ContentReducer() }))
}
