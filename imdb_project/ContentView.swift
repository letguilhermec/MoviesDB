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
  @State private var isSearching = false
  
    var body: some View {
      TabView(selection: $isSearching) {
        MovieListView(isSearching: $isSearching)
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
