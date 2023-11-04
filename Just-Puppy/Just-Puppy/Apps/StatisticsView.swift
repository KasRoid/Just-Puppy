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
                        item(with: emotion, analyses: analyses)
                    }
                }
                .scrollDisabled(true)
                .navigationTitle("Statistics")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private func item(with emotion: Emotion, analyses: [Analysis]) -> some View {
        HStack(spacing: 8) {
            Text(emotion.rawValue.capitalized)
            Spacer()
            Text("\(analyses.count)")
            if !analyses.isEmpty {
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 6, height: 8)
                    .foregroundStyle(Color(UIColor.lightGray))
            }
        }
    }
}

#Preview {
    StatisticsView(store: .init(initialState: .init(), reducer: { StatisticsReducer() }))
}
