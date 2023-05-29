//
//  AppLoadingView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 29/05/23.
//

import SwiftUI

struct AppLoadingView: View {
  @State private var showSplash = true
  
  var body: some View {
    if showSplash {
      SplashScreen()
        .ignoresSafeArea()
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
              showSplash = false
            }
          }
        }
    } else {
      ContentView()
        .transition(.scale(scale: 0, anchor: .top))
    }
  }
}

struct AppLoadingView_Previews: PreviewProvider {
  static var previews: some View {
    AppLoadingView()
  }
}
