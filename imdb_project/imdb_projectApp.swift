//
//  imdb_projectApp.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI
import AlanSDK

@main
struct imdb_projectApp: App {
  @StateObject private var appController = AppController.shared
  
  var isSearching: Binding<Bool> {
    Binding<Bool>(
      get: { appController.isSearching },
      set: { appController.isSearching = $0 }
    )
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(appController)
    }
  }
}
