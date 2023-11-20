//
//  SplashView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 9/3/23.
//

import SwiftUI

struct SplashView: View {
    
    @Binding var initialized: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Spacer().frame(height: 10)
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            Spacer().frame(height: 40)
            Text("Just Emotion Detector")
                .font(.largeTitle)
                .bold()
                .frame(alignment: .center)
            Spacer().frame(height: 8)
            Text("Identify your pet's emotion.")
                .font(.title3)
            Spacer()
        }
        .onAppear {
            AnalysisManager.shared.loadFiles()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                initialized = true
            }
        }
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(initialized: .constant(false))
    }
}
