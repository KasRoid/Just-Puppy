//
//  StatisticsAnalysesView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/4/23.
//

import ComposableArchitecture
import SwiftUI

struct StatisticsAnalysesView: View {
    
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<StatisticsAnalysesReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                ForEach(viewStore.analyses, id: \.self) { analysis in
                    LazyVStack {
                        item(with: analysis, viewStore: viewStore)
                    }
                    .listSectionSeparator(.hidden)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle(viewStore.emotion.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    JPNavigationBackButtonView { dismiss() }
                }
            }
            .navigationDestination(isPresented: viewStore.binding(get: { $0.isDetailPresented },
                                                                  send: StatisticsAnalysesReducer.Action.hideDetail)) {
                analysisView(viewStore: viewStore)
            }
        }
    }
}

// MARK: - UI
extension StatisticsAnalysesView {
    
    private func item(with analysis: Analysis, viewStore: ViewStoreOf<StatisticsAnalysesReducer>) -> some View {
        Button(action: { viewStore.send(.showDetail(analysis)) }) {
            HStack {
                Image(uiImage: analysis.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Spacer()
                Text(analysis.date.yyyyMMddDashed)
            }
        }
    }
    
    private func analysisView(viewStore: ViewStoreOf<StatisticsAnalysesReducer>) -> some View {
        let analysis = viewStore.selectedAnalysis
        let store: StoreOf<AnalysisReducer> = .init(initialState: .init(analysis: analysis), reducer: { AnalysisReducer() })
        return AnalysisView(type: .detail, closeAction: .dismiss, store: store)
    }
}
