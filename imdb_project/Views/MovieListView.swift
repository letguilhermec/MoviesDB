//
//  MovieListView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI

struct MovieListView: View {
  @ObservedObject private var nowPlayingState = MovieListState()
  @ObservedObject private var upcomingState = MovieListState()
  @ObservedObject private var topRatedState = MovieListState()
  @ObservedObject private var popularState = MovieListState()
  
  var body: some View {
    NavigationView {
      List {
        Group {
          if nowPlayingState.movies != nil {
            MoviePosterCarouselView(title: "Now Playing", movies: nowPlayingState.movies!)
          } else {
            LoadingView(isLoading: self.nowPlayingState.isLoading, error: self.nowPlayingState.error) {
              self.nowPlayingState.loadMovies(with: .nowPlaying)
            }
          }
        }
        
        Group {
          if upcomingState.movies != nil {
            MovieBackdropCarouselView(title: "Upcoming", movies: upcomingState.movies!)
          } else {
            LoadingView(isLoading: self.upcomingState.isLoading, error: self.upcomingState.error) {
              self.upcomingState.loadMovies(with: .upcoming)
            }
          }
        }
       
        Group {
          if topRatedState.movies != nil {
            MovieBackdropCarouselView(title: "Top Rated", movies: topRatedState.movies!)
          } else {
            LoadingView(isLoading: self.topRatedState.isLoading, error: self.topRatedState.error) {
              self.topRatedState.loadMovies(with: .topRated)
            }
          }
        }
        
        Group {
          if popularState.movies != nil {
            MovieBackdropCarouselView(title: "Popular", movies: popularState.movies!)
          } else {
            LoadingView(isLoading: self.popularState.isLoading, error: self.popularState.error) {
              self.popularState.loadMovies(with: .popular)
            }
          }
        }
        
      }
      .navigationBarTitle("The MovieDB")
    }
    .onAppear {
      self.nowPlayingState.loadMovies(with: .nowPlaying)
      self.upcomingState.loadMovies(with: .upcoming)
      self.topRatedState.loadMovies(with: .topRated)
      self.popularState.loadMovies(with: .popular)
    }
  }
}

struct MovieListView_Previews: PreviewProvider {
  static var previews: some View {
    MovieListView()
  }
}
