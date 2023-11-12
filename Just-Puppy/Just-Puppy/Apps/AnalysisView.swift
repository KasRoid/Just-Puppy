//
//  AnalysisView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import ComposableArchitecture
import SwiftUI

enum AnalysisViewType {
    case detail
    case result
}

struct AnalysisView: View {
    
    @Environment(\.dismiss) var dismiss
    let type: AnalysisViewType
    let closeAction: CloseAction
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
                buttonsView(with: viewStore)
                Spacer().frame(height: 20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                JPNavigationBackButtonView { dismiss() }
            }
        }
    }
}

// MARK: - UI
extension AnalysisView {

    private func imageView(with viewStore: ViewStoreOf<AnalysisReducer>) -> some View {
        let image = viewStore.analysis?.image ?? UIImage()
        return Image(uiImage: image)
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
                Text(viewStore.analysis?.date.yyyyMMddHHmmss ?? "No date")
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
    
    @ViewBuilder
    private func descriptionView(with viewStore: ViewStoreOf<AnalysisReducer>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Description")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            let description = viewStore.analysis?.emotion != Emotion.none
            ? getDescription(with: viewStore)
            : "Unable to analyze emotion."
            Text(description)
                .font(.system(size: 16))
                .foregroundStyle(Color.gray)
        }
        .padding(.horizontal, 16)
    }
    
    private func buttonsView(with viewStore: ViewStoreOf<AnalysisReducer>) -> some View {
        HStack(spacing: 12) {
            deletePhotoButtonView(with: viewStore)
            if type == .result {
                savePhotoButtonView(with: viewStore)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
    }
    
    private func deletePhotoButtonView(with viewStore: ViewStoreOf<AnalysisReducer>) -> some View {
        JPOutlinedButtonView(title: "Delete") {
            viewStore.send(.deleteAnalysis)
            close()
        }
        .frame(maxWidth: .infinity)
    }
    
    private func savePhotoButtonView(with viewStore: ViewStoreOf<AnalysisReducer>) -> some View {
        JPFilledButtonView(title: "Save") {
            viewStore.send(.saveAnalysis)
            close()
        }
        .frame(maxWidth: .infinity)
    }
    
    private func getDescription(with viewStore: ViewStoreOf<AnalysisReducer>) -> String {
        let keys = viewStore.analysis?.probabilities.sorted { $0.value > $1.value }.map(\.key) ?? []
        let firstKey = keys[0]
        let secondKey = keys[1]
        let firstProbability = viewStore.analysis?.probabilities[firstKey]
        let firstProposition = getProposition(probability: firstProbability)
        let secondProbability = viewStore.analysis?.probabilities[secondKey]
        let secondProposition = getProposition(probability: secondProbability)
        return "Your puppy is \(firstProposition)\(firstKey) and \(secondProposition)\(secondKey)"
    }
    
    private func getProposition(probability: Double?) -> String {
        guard let probability else { return "" }
        if probability > 0.5 {
            return "very "
        } else if probability > 0.2 {
            return "little "
        } else {
            return ""
        }
    }
}

// MARK: - Private Functions
extension AnalysisView {
    
    private func close() {
        switch closeAction {
        case .dismiss:
            dismiss()
        case .goToRoot:
            NotificationCenter.default.post(name: .goToRoot, object: nil)
        }
    }
}

// MARK: - Enums
extension AnalysisView {
    
    enum CloseAction {
        case dismiss
        case goToRoot
    }
}

#Preview {
    AnalysisView(type: .detail, closeAction: .dismiss, store: .init(initialState: AnalysisReducer.State(analysis: nil),
                                                                    reducer: { AnalysisReducer() }))
}
