//
//  FileSavingEnvironment.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/22/23.
//

import ComposableArchitecture
import Foundation
import UIKit

struct FileSavingEnvironment {
    var analysis: (Analysis) -> Result<Void, Error>
}

extension FileSavingEnvironment: DependencyKey {
    
    static var liveValue = FileSavingEnvironment { analysis in
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryPath = documentPath.appendingPathComponent("emotion_analyses")
        
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false, attributes: nil)
            let filePath = directoryPath.appendingPathComponent(analysis.date.yyyyMMddHHmmssNoSeperator)
            let data = try JSONEncoder().encode(analysis)
            try data.write(to: filePath)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

extension DependencyValues {
    
    var fileSavingEnvironment: FileSavingEnvironment {
        get { self[FileSavingEnvironment.self] }
        set { self[FileSavingEnvironment.self] = newValue }
    }
}
