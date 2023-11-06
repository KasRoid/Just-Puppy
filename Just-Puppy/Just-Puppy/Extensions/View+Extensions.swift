//
//  View+Extensions.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/5/23.
//

import SwiftUI

extension View {

    func asUIImage() async -> UIImage {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                let controller = UIHostingController(rootView: self)
                
                // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
                controller.view.backgroundColor = .clear
                
                controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
                
                let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.windows.first
                window?.rootViewController?.view.addSubview(controller.view)
                
                let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
                controller.view.bounds = CGRect(origin: .zero, size: size)
                controller.view.sizeToFit()
                
                // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
                let image = controller.view.asUIImage()
                controller.view.removeFromSuperview()
                continuation.resume(returning: image)
            }
        }
    }
}
