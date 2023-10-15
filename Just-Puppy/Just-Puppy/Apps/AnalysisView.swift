//
//  AnalysisView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import ComposableArchitecture
import SwiftUI

struct AnalysisView: View {
    
    let store: StoreOf<AnalysisReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                imageView(with: viewStore)
                Spacer().frame(height: 20)
                titleView(with: viewStore)
                Spacer().frame(height: 40)
                descriptionView(with: viewStore)
                Spacer()
                deletePhotoButtonView
                Spacer().frame(height: 20)
            }
        }
        .toolbar(.hidden)
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - UI
extension AnalysisView {
    
    @ViewBuilder
    private func imageView(with viewStore: ViewStoreOf<AnalysisReducer>) -> some View {
        let image = viewStore.analysis?.image ?? UIImage()
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .clipped()
    }
    
    private func titleView(with viewStore: ViewStoreOf<AnalysisReducer>) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Expression")
                    .font(.system(size: 20, weight: .bold))
                Text(viewStore.analysis?.date.description ?? "No date")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            VStack(spacing: 8) {
                Text(viewStore.analysis?.emotion.rawValue.capitalized ?? "Error")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule().fill(Color.mainRed)
                    )
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func descriptionView(with viewStore: ViewStoreOf<AnalysisReducer>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Description")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            Text("Get detailed information about your dog's expression and receive suggestions on how to improve it.")
                .font(.system(size: 14))
                .foregroundStyle(Color.gray)
                
        }
        .padding(.horizontal, 16)
    }
    
    private var deletePhotoButtonView: some View {
        JPOutlinedButtonView(title: "Delete") {
            print("Delete")
        }
        .padding(.horizontal, 16)
    }
    
    private var savePhotoButtonView: some View {
        JPFilledButtonView(title: "Save") {
            print("Save")
        }
    }
}

#Preview {
    AnalysisView(store: .init(initialState: AnalysisReducer.State(analysis: nil),
                              reducer: { AnalysisReducer() }))
}
