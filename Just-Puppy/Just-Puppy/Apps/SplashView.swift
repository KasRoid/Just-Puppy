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
            Image("logo")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Spacer().frame(height: 10)
            Text("감정을 잇다")
                .font(.title3)
            Text("Just Connect.")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding()
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
