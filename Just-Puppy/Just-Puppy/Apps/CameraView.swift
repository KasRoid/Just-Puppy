//
//  CameraView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import AVFoundation
import Combine
import ComposableArchitecture
import SwiftUI
import UIKit

struct CameraView: View {
    
    @State private var capturedImage: UIImage?
    @State private var isReviewPresented = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            CameraViewRepresentable(capturedImage: $capturedImage, isReviewPresented: $isReviewPresented)
                .ignoresSafeArea()
                .toolbar(.hidden)
                .navigationDestination(isPresented: $isReviewPresented) {
                    PhotoReviewView()
                }
        }
    }
}

// MARK: - UIViewControllerRepresentable
struct CameraViewRepresentable: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    @Binding var capturedImage: UIImage?
    @Binding var isReviewPresented: Bool
    
    private let store = Store(initialState: .init(), reducer:  { CameraReducer() })
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CameraViewController(store: store, cancelAction: { dismiss() })
        context.coordinator.bind(store: store) {
            self.capturedImage = $0
            self.isReviewPresented = true
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        
        var parent: CameraViewRepresentable
        private var cancellables = Set<AnyCancellable>()
        
        init(_ parent: CameraViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        fileprivate func bind(store: Store<CameraReducer.State, CameraReducer.Action>, handler: @escaping (UIImage?) -> Void) {
            store.publisher.capturedImage
                .compactMap { $0 }
                .sink { handler($0) }
                .store(in: &cancellables)
        }
    }
}
