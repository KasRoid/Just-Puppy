//
//  Just_PuppyApp.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 9/3/23.
//

import SwiftUI

@main
struct Just_PuppyApp: App {

    @State private var initialized = false
    @State private var selectedTab: JPTab = .home
    @State private var isCameraPresented = false
    @State private var capturedImage: UIImage?
    
    var body: some Scene {
        WindowGroup {
            if initialized {
                tabView
                    .fullScreenCover(isPresented: $isCameraPresented) {
                        CameraView(capturedImage: $capturedImage)
                    }
            } else {
                SplashView(initialized: $initialized)
            }
        }
    }
}

// MARK: - UI
extension Just_PuppyApp {
    
    private var tabView: some View {
        JPTabView(selectedTab: $selectedTab, action: showCamera) {
            homeView
            favoritesView
        }
    }
    
    private var homeView: some View {
        HomeView(store: .init(initialState: .init(),
                              reducer: { MainReducer() })
        )
        .tabBarItem(.home, selectedTab: $selectedTab)
    }
    
    private var favoritesView: some View {
        FavoritesView()
            .tabBarItem(.favorites, selectedTab: $selectedTab)
    }
}

// MARK: - Private Functions
extension Just_PuppyApp {
    
    private func showCamera() {
        isCameraPresented = true
    }
}
