//
//  UIView+Extensions.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/5/23.
//

import UIKit

extension UIView {
    
    func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
