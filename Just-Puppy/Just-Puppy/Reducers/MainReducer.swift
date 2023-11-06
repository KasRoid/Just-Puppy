//
//  MainReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/1/23.
//

import ComposableArchitecture
import Foundation
import OrderedCollections
import PhotosUI
import SwiftUI

struct MainReducer: Reducer {
    
    @Dependency(\.dogEmotionClassificationEnvironment) var dogEmotionClassificationEnvironment
    
    struct State: Equatable {
        var analyses: OrderedSet<Analysis>
        var selectedAnalysis: Analysis?
        var selectedItem: PhotosPickerItem?
        var isAnalysisPresented = false
        var type: AnalysisViewType = .detail
    }
    
    enum Action {
        case setAnalyses(OrderedSet<Analysis>)
        case selectPhoto(PhotosPickerItem?)
        case toggleFavorite(Analysis)
        case showAnalysis(Analysis?)
        case showDetail(Analysis)
        case analyze(UIImage)
        case hide
    }
    
    var body: some ReducerOf<MainReducer> {
        Reduce { state, action in
            switch action {
            case .setAnalyses(let analyses):
                state.analyses = analyses
            case .selectPhoto(let item):
                return loadTransferableEffect(from: item, state: state)
            case .analyze(let image):
                return dogClassificationEffect(with: image)
            case .toggleFavorite(var analysis):
                let updatedAnalysis = analysis.update(isFavorite: !analysis.isFavorite)
                AnalysisManager.shared.saveAnalysis(updatedAnalysis)
            case .showAnalysis(let analysis):
                state.type = .result
                state.selectedAnalysis = analysis
                state.isAnalysisPresented = true
            case .showDetail(let analysis):
                state.type = .detail
                state.selectedAnalysis = analysis
                state.isAnalysisPresented = true
            case .hide:
                state.isAnalysisPresented = false
            }
            return .none
        }
    }
}

// MARK: - Private Functions
extension MainReducer {
    
    private func loadTransferableEffect(from item: PhotosPickerItem?, state: MainReducer.State) -> Effect<MainReducer.Action> {
        return .run { send in
            do {
                guard let image = try await item?.loadTransferable(type: AnalysisImage.self)?.image else { return }
                let uiImage = await image.asUIImage()
                await send(.analyze(uiImage))
            } catch {
                print(error)
            }
        }
    }
    
    private func dogClassificationEffect(with image: UIImage) -> Effect<Action> {
        return .run { send in
            let analysis = dogEmotionClassificationEnvironment.analysis(image)
            await send(.showAnalysis(analysis))
        }
    }
}
