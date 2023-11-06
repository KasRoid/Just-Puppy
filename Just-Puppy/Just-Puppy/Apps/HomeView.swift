//
//  HomeView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/1/23.
//

import ComposableArchitecture
import PhotosUI
import SwiftUI

struct HomeView: View {
    
    let store: StoreOf<MainReducer>
    @State private var buttonID = UUID()
    @State var selectedItem: PhotosPickerItem?
    
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
                        noDataView(viewStore)
                    } else {
                        listView(viewStore)
                    }
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .onReceive(AnalysisManager.shared.$analyses) { viewStore.send(.setAnalyses($0)) }
                .navigationDestination(isPresented: viewStore.binding(get: { $0.isAnalysisPresented },
                                                                      send: MainReducer.Action.hide)) {
                    analysisView(viewStore: viewStore)
                }
            }
        }
    }
    
    private func noDataView(_ viewStore: ViewStoreOf<MainReducer>) -> some View {
        VStack {
            uploadPhotoView(viewStore)
            Spacer()
            Text("No Data")
            Spacer()
        }
    }
    
    private func listView(_ viewStore: ViewStoreOf<MainReducer>) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    uploadPhotoView(viewStore)
                        .id(buttonID)
                    ForEach(viewStore.analyses, id: \.self) { analysis in
                        Button {
                            viewStore.send(.showDetail(analysis))
                        } label: {
                            analysisItemView(with: analysis, viewStore: viewStore)
                        }
                    }
                    .animation(.easeIn, value: viewStore.analyses)
                }
                .padding(.horizontal, 16)
            }
            .onReceive(NotificationCenter.default.publisher(for: .tabBarTapped)) { output in
                guard let tab = output.object as? JPTab, tab == .home else { return }
                withAnimation {
                    proxy.scrollTo(buttonID)
                }
            }
        }
    }
    
    private func uploadPhotoView(_ viewStore: ViewStoreOf<MainReducer>) -> some View {
        PhotosPicker(selection: viewStore.binding(get: { $0.selectedItem }, send: MainReducer.Action.selectPhoto),
                     matching: .images,
                     photoLibrary: .shared()) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.mainRed, lineWidth: 1)
                Text("Upload a photo")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.mainRed)
            }
            .frame(height: 48)
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
    
    private func analysisView(viewStore: ViewStoreOf<MainReducer>) -> some View {
        let analysis = viewStore.selectedAnalysis
        let store: StoreOf<AnalysisReducer> = .init(initialState: .init(analysis: analysis), reducer: { AnalysisReducer() })
        let type = viewStore.type
        return AnalysisView(type: type, closeAction: .dismiss, store: store)
    }
}

// MARK: - Preview
#Preview {
    HomeView(store: .init(initialState: MainReducer.State(analyses: []),
                          reducer: { MainReducer() })
    )
}
