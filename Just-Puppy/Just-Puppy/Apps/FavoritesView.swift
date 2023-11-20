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
                listView(viewStore: viewStore)
            }
        }
    }
}

// MARK: - UI
extension FavoritesView {
    
    private func listView(viewStore: ViewStoreOf<FavoriteReducer>) -> some View {
        List {
            ForEach(viewStore.analyses, id: \.self) { analysis in
                Button {
                    viewStore.send(.showDetail(analysis))
                } label: {
                    analysisItemView(with: analysis, viewStore: viewStore)
                }
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        viewStore.send(.toggleFavorite(analysis))
                    } label: {
                        Image(systemName: "star.slash")
                    }
                    .background(Color.mainRed)
                }
            }
            .padding(.horizontal, 8)
        }
        .listStyle(.plain)
        .onReceive(AnalysisManager.shared.$analyses) { viewStore.send(.setAnalyses($0)) }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: viewStore.binding(get: { $0.isAnalysisPresented },
                                                              send: FavoriteReducer.Action.hideDetail)) {
            let analysis = viewStore.selectedAnalysis
            let store: StoreOf<AnalysisReducer> = .init(initialState: .init(analysis: analysis),
                                                        reducer: { AnalysisReducer() })
            AnalysisView(type: .detail, closeAction: .dismiss, store: store)
        }
    }
    
    private func analysisItemView(with analysis: Analysis, viewStore: ViewStoreOf<FavoriteReducer>) -> some View {
        HStack(spacing: 0) {
            Image(uiImage: analysis.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Spacer().frame(width: 20)
            VStack(alignment: .leading, spacing: 8) {
                Text(analysis.emotion.title)
                    .foregroundStyle(Color.primary)
                    .font(.system(size: 20, weight: .bold))
                Text(analysis.date.yyyyMMddDashed)
                    .foregroundStyle(Color.primary)
                    .font(.system(size: 14, weight: .regular))
            }
            Spacer()
        }
        .frame(height: 100)
    }
}

// MARK: - Preview
#Preview {
    FavoritesView(store: .init(initialState: FavoriteReducer.State(analyses: []), reducer: { FavoriteReducer() }))
}
