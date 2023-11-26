//
//  AnalysisImage.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/5/23.
//

import SwiftUI

struct AnalysisImage: Transferable {
    
    let image: UIImage
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let compressedData = UIImage(data: data)?.jpegData(compressionQuality: 0.05),
                  let uiImage = UIImage(data: compressedData) else {
                throw TransferError.importFailed
            }
//            let image = Image(uiImage: uiImage)
            return AnalysisImage(image: uiImage)
        }
    }
}

enum TransferError: Error {
    case importFailed
}
