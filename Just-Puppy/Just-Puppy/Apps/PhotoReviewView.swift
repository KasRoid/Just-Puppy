//
//  PhotoReviewView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/7/23.
//

import SwiftUI

struct PhotoReviewView: View {
    
    @State var capturedImage: UIImage?
    
    var body: some View {
        if let image = capturedImage {
            Image(uiImage: image)
                .resizable()
                .frame(width: 200, height: 200)
                .aspectRatio(contentMode: .fit)
        }
    }
}

// MARK: - Preview
#Preview {
    PhotoReviewView()
}
