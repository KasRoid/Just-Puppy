//
//  AnalysisImage.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/5/23.
//

import SwiftUI

struct AnalysisImage: Transferable {
    
    let image: Image
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw TransferError.importFailed
            }
            let image = Image(uiImage: uiImage)
            return AnalysisImage(image: image)
        }
    }
}

enum TransferError: Error {
    case importFailed
}
