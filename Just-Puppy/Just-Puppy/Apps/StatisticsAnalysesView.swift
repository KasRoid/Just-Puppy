//
//  StatisticsAnalysesView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/4/23.
//

import ComposableArchitecture
import SwiftUI

struct StatisticsAnalysesView: View {
    
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
        }
    }
}

// MARK: - UI
extension StatisticsAnalysesView {
    
    private func item(with analysis: Analysis, viewStore: ViewStoreOf<StatisticsAnalysesReducer>) -> some View {
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
