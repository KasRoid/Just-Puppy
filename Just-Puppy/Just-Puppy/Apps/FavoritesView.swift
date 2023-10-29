//
//  FavoritesView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import ComposableArchitecture
import SwiftUI

struct FavoritesView: View {
    
    let store: StoreOf<FavoriteReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewStore.analyses, id: \.self) { analysis in
                            Button {
                                viewStore.send(.showDetail(analysis))
                            } label: {
                                analysisItemView(with: analysis, viewStore: viewStore)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .onReceive(AnalysisManager.shared.$analyses) { viewStore.send(.setAnalyses($0)) }
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

// MARK: - UI
extension FavoritesView {
    
    private func analysisItemView(with analysis: Analysis, viewStore: ViewStoreOf<FavoriteReducer>) -> some View {
        ZStack {
            Image(uiImage: analysis.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 210)
                .frame(maxWidth: .infinity)
                .clipped()
            VStack {
                Spacer().frame(height: 12)
                HStack {
                    Spacer()
                    Image(systemName: analysis.isFavorite ? "star.fill" : "star")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.mainRed)
                        .onTapGesture { viewStore.send(.toggleFavorite(analysis)) }
                    Spacer().frame(width: 12)
                }
                Spacer()
                HStack {
                    Spacer().frame(width: 8)
                    Text(analysis.emotion.rawValue.capitalized)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.mainRed)
                    Spacer()
                }
                HStack {
                    Spacer().frame(width: 8)
                    Text(analysis.date.yyyyMMddDashed)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.mainRed)
                    Spacer()
                }
                Spacer().frame(height: 12)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Preview
#Preview {
    FavoritesView(store: .init(initialState: FavoriteReducer.State(analyses: []), reducer: { FavoriteReducer() }))
}
