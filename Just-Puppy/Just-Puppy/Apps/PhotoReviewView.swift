//
//  PhotoReviewView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/7/23.
//

import ComposableArchitecture
import SwiftUI

struct PhotoReviewView: View {
    
    let store: StoreOf<PhotoReviewReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                imageView(with: viewStore)
                Spacer()
                descriptionView
                Spacer()
                analyzeButtonView(with: viewStore)
                Spacer().frame(height: 16)
            }
            .toolbar(.hidden)
            .ignoresSafeArea(edges: .top)
        }
    }
}

// MARK: - UI
extension PhotoReviewView {
    
    private func imageView(with viewStore: ViewStoreOf<PhotoReviewReducer>) -> some View {
        Image(uiImage: viewStore.capturedImage)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(contentMode: .fit)
            .overlay {
                goBackButtonView(with: viewStore)
            }
    }
    
    private func goBackButtonView(with viewStore: ViewStoreOf<PhotoReviewReducer>) -> some View {
        VStack {
            HStack {
                JPNavigationBackButtonView { viewStore.send(.goBack) }
                Spacer()
            }
            Spacer()
        }
        .padding(.top, 60)
        .padding(.leading, 16)

    }
    
    private var descriptionView: some View {
        Text("How is your dog\nfeeling right now?")
            .font(.system(size: 16))
            .multilineTextAlignment(.center)
    }
    
    private func analyzeButtonView(with viewStore: ViewStoreOf<PhotoReviewReducer>) -> some View {
        JPFilledButtonView(title: "Analyze") {
            viewStore.send(.analyze)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    PhotoReviewView(store: .init(initialState: PhotoReviewReducer.State(capturedImage: UIImage()),
                                 reducer: { PhotoReviewReducer() }))
}
