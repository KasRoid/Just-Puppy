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
                    if viewStore.analyses.isEmpty {
                        noDataView
                    } else {
                        listView(viewStore)
                    }
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .onReceive(AnalysisManager.shared.$analyses) { viewStore.send(.setAnalyses($0)) }
                .navigationDestination(isPresented: viewStore.binding(get: { $0.isAnalysisPresented },
                                                                      send: MainReducer.Action.hideDetail)) {
                    let analysis = viewStore.selectedAnalysis
                    let store: StoreOf<AnalysisReducer> = .init(initialState: .init(analysis: analysis),
                                                                reducer: { AnalysisReducer() })
                    AnalysisView(type: .detail, store: store)
                }
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
    }
    
    private func analysisItemView(with analysis: Analysis, viewStore: ViewStoreOf<MainReducer>) -> some View {
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
    HomeView(store: .init(initialState: MainReducer.State(analyses: []),
                          reducer: { MainReducer() })
    )
}
