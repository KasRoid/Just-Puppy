//
//  StatisticsView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/4/23.
//

import ComposableArchitecture
import SwiftUI

struct StatisticsView: View {
    
    let store: StoreOf<StatisticsReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                List {
                    ForEach(viewStore.analyses.keys, id: \.self) { emotion in
                        let analyses = viewStore.analyses[emotion] ?? []
                        item(with: emotion, analyses: analyses, viewStore: viewStore)
                    }
                }
                .scrollDisabled(true)
                .navigationTitle("Statistics")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: viewStore.binding(get: { $0.isListPresented },
                                                                      send: StatisticsReducer.Action.hideList)) {
                    if let emotion = viewStore.selectedEmotion {
                        let analyses = viewStore.analyses[emotion] ?? []
                        let store = StoreOf<StatisticsAnalysesReducer>(initialState: .init(emotion: emotion, analyses: analyses),
                                                                       reducer: { StatisticsAnalysesReducer() })
                        StatisticsAnalysesView(store: store)
                    }
                }
            }
        }
    }
}

// MARK: - UI
extension StatisticsView {
    
    private func item(with emotion: Emotion, analyses: [Analysis], viewStore: ViewStoreOf<StatisticsReducer>) -> some View {
        Button(action: { viewStore.send(.showList(emotion)) }) {
            HStack(spacing: 8) {
                Text(emotion.rawValue.capitalized)
                    .foregroundStyle(Color.primary)
                Spacer()
                Text("\(analyses.count)")
                    .foregroundStyle(Color.primary)
                if !analyses.isEmpty {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 6, height: 8)
                        .foregroundStyle(Color(UIColor.lightGray))
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    StatisticsView(store: .init(initialState: .init(), reducer: { StatisticsReducer() }))
}
