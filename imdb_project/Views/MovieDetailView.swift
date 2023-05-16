//
//  MovieDetailView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI

struct MovieDetailView: View {
  let movieId: Int
  @ObservedObject private var movieDetailState = MovieDetailState()
  
  var body: some View {
    ZStack {
      LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
        self.movieDetailState.loadMovie(id: self.movieId)
      }
      if movieDetailState.movie != nil {
        MovieDetailListView(movie: self.movieDetailState.movie!)
      }
    }
    .navigationBarTitle(movieDetailState.movie?.title ?? "")
    .onAppear {
      self.movieDetailState.loadMovie(id: self.movieId)
    }
  }
}

struct MovieDetailListView: View {
  let movie: Movie
  
  var body: some View {
    List {
      MovieDetailImage(imageURL: self.movie.backdropURL)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
  }
}

struct MovieDetailImage: View {
  @ObservedObject private var imageLoader = ImageLoader()
  let imageURL: URL
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color.gray.opacity(0.3))
      if self.imageLoader.image != nil {
        Image(uiImage: self.imageLoader.image!)
          .resizable()
      }
    }
    .aspectRatio(16/9, contentMode: .fit)
    .onAppear {
      self.imageLoader.loadImage(with: self.imageURL)
    }
  }
}

struct MovieDetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView{
      MovieDetailView(movieId: Movie.stubbedMovie.id)
    }
  }
}
