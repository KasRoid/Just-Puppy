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

struct CameraView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CameraViewController(store: Store(initialState: .init(),
                                                           reducer: { CameraReducer() })
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
            super.init()
        }
    }
}
