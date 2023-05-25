//
//  ContentView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI
import AlanSDK

struct ContentView: View {
  let alanManager = UIApplication.shared
  @EnvironmentObject private var appController: AppController
  
    var body: some View {
      TabView(selection: $appController.isSearching) {
        MovieListView()
          .tabItem {
            VStack {
              Image(systemName: "tv")
              Text("Movies")
            }
          }
          .tag(false)
        
        MovieSearchView()
          .tabItem {
            VStack {
              Image(systemName: "magnifyingglass")
              Text("Search")
            }
          }
          .tag(true)
      }
      .onAppear {
        alanManager.addAlan()
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
        .environmentObject(AppController.shared)
    }
}
