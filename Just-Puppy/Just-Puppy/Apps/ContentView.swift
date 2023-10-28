//
//  ContentView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/3/23.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    
    let store: StoreOf<ContentReducer>
    let homeViewStore = StoreOf<MainReducer>(initialState: .init(), reducer: { MainReducer() })
    
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
    
    private func homeView(with viewState: ViewStore<ContentReducer.State, ContentReducer.Action>) -> some View {
        HomeView(store: homeViewStore)
            .tabBarItem(.home, selectedTab: viewState.binding(get: { $0.selectedTab },
                                                              send: ContentReducer.Action.select))
    }
    
    private func favoritesView(with viewState: ViewStore<ContentReducer.State, ContentReducer.Action>) -> some View {
        FavoritesView()
            .tabBarItem(.favorites, selectedTab: viewState.binding(get: { $0.selectedTab },
                                                                   send: ContentReducer.Action.select))
    }
}

// MARK: - Preview
#Preview {
    ContentView(store: .init(initialState: .init(), reducer: { ContentReducer() }))
}
