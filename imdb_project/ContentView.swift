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
  
    var body: some View {
      TabView {
        MovieListView()
          .tabItem {
            VStack {
              Image(systemName: "tv")
              Text("Movies")
            }
          }
          .tag(0)
        
        MovieSearchView()
          .tabItem {
            VStack {
              Image(systemName: "magnifyingglass")
              Text("Search")
            }
          }
          .tag(1)
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
