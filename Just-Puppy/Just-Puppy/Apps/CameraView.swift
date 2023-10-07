//
//  CameraView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import AVFoundation
import ComposableArchitecture
import SwiftUI
import UIKit

struct CameraView: View {
    
    @State private var isReviewPresented = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            CameraViewRepresentable(isReviewPresented: $isReviewPresented)
                .ignoresSafeArea()
                .toolbar(.hidden)
                .navigationDestination(isPresented: $isReviewPresented) {
                    PhotoReviewView()
                }
        }
    }
}

struct CameraViewRepresentable: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    @Binding var isReviewPresented: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let store = Store(initialState: .init(), reducer:  { CameraReducer() })
        let controller = CameraViewController(store: store, cancelAction: { dismiss() })
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CameraViewRepresentable
        
        init(_ parent: CameraViewRepresentable) {
            self.parent = parent
            super.init()
        }
    }
}
