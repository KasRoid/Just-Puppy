//
//  FileLoadingEnvironment.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/22/23.
//

import ComposableArchitecture
import Foundation

struct FileLoadingEnvironment {
    var analyses: [Analysis]?
}

extension FileLoadingEnvironment: DependencyKey {
    
    static var liveValue: Self {
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryPath = documentPath.appendingPathComponent("emotion_analyses")
        
        guard let fileURLs = try? fileManager.contentsOfDirectory(at: directoryPath,
                                                                  includingPropertiesForKeys: [.contentModificationDateKey],
                                                                  options:.skipsHiddenFiles) else { return .init(analyses: nil) }
        let sortedURLs = fileURLs.map { url in
            ( url, (try? url.resourceValues(forKeys: [.contentModificationDateKey]) )?.contentModificationDate ?? Date.distantPast)
        }
        .sorted(by: { $0.1 > $1.1 })
        .map { $0.0 }
        
        var analyses: [Analysis] = []
        
        do {
            for url in sortedURLs {
                let data = try Data(contentsOf: url)
                let analysis = try JSONDecoder().decode(Analysis.self, from: data)
                analyses.append(analysis)
            }
        } catch {
            return .init(analyses: nil)
        }
        return .init(analyses: analyses)
    }
}

extension DependencyValues {
    
    var fileLoadingEnvironment: FileLoadingEnvironment {
        get { FileLoadingEnvironment.liveValue }
        set { self[FileLoadingEnvironment.self] = newValue }
    }
}
