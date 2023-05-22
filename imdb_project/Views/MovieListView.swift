//
//  MovieListView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI
import AlanSDK

struct MovieListView: View {
  @ObservedObject private var nowPlayingState = MovieListState()
  @ObservedObject private var upcomingState = MovieListState()
  @ObservedObject private var topRatedState = MovieListState()
  @ObservedObject private var popularState = MovieListState()
  
  @StateObject private var appController = AppController.shared
  
  var isUpcomingBinding: Binding<Bool> {
    Binding<Bool>(
      get: { self.appController.isUpcomingOpen },
      set: { self.appController.isUpcomingOpen = $0 }
    )
  }
  
  var isPopularBinding: Binding<Bool> {
    Binding<Bool>(
      get: { self.appController.isPopularOpen },
      set: { self.appController.isPopularOpen = $0 }
    )
  }

  var isTopRatedBinding: Binding<Bool> {
    Binding<Bool>(
      get: { self.appController.isTopRatedOpen },
      set: { self.appController.isTopRatedOpen = $0 }
    )
  }
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
        .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
        
        Group {
          if upcomingState.movies != nil {
            NavigationLink(destination: VerticalListView(title: "Upcoming", movies: upcomingState.movies!), isActive: isUpcomingBinding) {
              MovieBackdropCarouselView(title: "Upcoming", movies: upcomingState.movies!)
            }
          } else {
            LoadingView(isLoading: self.upcomingState.isLoading, error: self.upcomingState.error) {
              self.upcomingState.loadMovies(with: .upcoming)
            }
          }
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
       
        Group {
          if topRatedState.movies != nil {
            NavigationLink(destination: VerticalListView(title: "Top Rated", movies: topRatedState.movies!), isActive: isTopRatedBinding) {
              MovieBackdropCarouselView(title: "Top Rated", movies: topRatedState.movies!)
            }
          } else {
            LoadingView(isLoading: self.topRatedState.isLoading, error: self.topRatedState.error) {
              self.topRatedState.loadMovies(with: .topRated)
            }
          }
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        
        Group {
          if popularState.movies != nil {
            NavigationLink(destination: VerticalListView(title: "Popular", movies: popularState.movies!), isActive: isPopularBinding) {
              MovieBackdropCarouselView(title: "Popular", movies: popularState.movies!)
            }
          } else {
            LoadingView(isLoading: self.popularState.isLoading, error: self.popularState.error) {
              self.popularState.loadMovies(with: .popular)
            }
          }
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        
      }
      .navigationBarTitle("The MovieDB")
      .padding(.horizontal, -20)
    }
    .onAppear {
      self.nowPlayingState.loadMovies(with: .nowPlaying)
      self.upcomingState.loadMovies(with: .upcoming)
      self.topRatedState.loadMovies(with: .topRated)
      self.popularState.loadMovies(with: .popular)
//      self.nowPlayingState.movies = Movie.stubbedMovies
//      self.upcomingState.movies = Movie.stubbedMovies
//      self.topRatedState.movies = Movie.stubbedMovies
//      self.popularState.movies = Movie.stubbedMovies
    }
  }
}

struct MovieListView_Previews: PreviewProvider {
  static var previews: some View {
    MovieListView()
  }
}
