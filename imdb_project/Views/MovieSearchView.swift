//
//  MovieSearchView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 17/05/23.
//

import SwiftUI

struct MovieSearchView: View {
  @ObservedObject var movieSearchState = MovieSearchState()
  @EnvironmentObject private var appController: AppController
  
  var isShown: Binding<Bool> {
    Binding<Bool>(
      get: { appController.isShowingMovieDetails },
      set: { appController.isShowingMovieDetails = $0 }
    )
  }
  
  var body: some View {
    NavigationView {
      List {
        SearchBarView(placeholder: "Search movies", text: self.$movieSearchState.query)
          .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
          .listRowSeparator(.hidden)
        
        LoadingView(isLoading: self.movieSearchState.isLoading, error: self.movieSearchState.error) {
          self.movieSearchState.search(query: self.movieSearchState.query)
        }
        
        if self.movieSearchState.movies != nil {
          ForEach(self.movieSearchState.movies!) { movie in
            Button {
              appController.showingMovieId = movie.id
              appController.isShowingMovieDetails = true
            } label: {
              VStack(alignment: .leading) {
                Text(movie.title)
                Text(movie.yearText)
              }
            }
          }
        }
      }
      .onAppear {
        self.movieSearchState.startObserve()
      }
      .sheet(isPresented: isShown) {
        if let movieId = appController.showingMovieId {
          MovieDetailView(movieId: movieId)
        }
      }
      .listStyle(.plain)
      .navigationBarTitle("Search")
    }
  }
}

struct MovieSearchView_Previews: PreviewProvider {
  static var previews: some View {
    MovieSearchView()
      .environmentObject(AppController.shared)
  }
}
