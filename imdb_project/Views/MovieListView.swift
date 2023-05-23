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
  let alanManager = UIApplication.shared
  
  @StateObject private var appController = AppController.shared
  
  var body: some View {
    NavigationView {
      ScrollViewReader { scrollViewProxy in
        ScrollView(.vertical, showsIndicators: false) {
          Group {
            if nowPlayingState.movies != nil {
              MoviePosterCarouselView(title: "Now Playing", movies: nowPlayingState.movies!)
            } else {
              LoadingView(isLoading: self.nowPlayingState.isLoading, error: self.nowPlayingState.error) {
                self.nowPlayingState.loadMovies(with: .nowPlaying)
              }
            }
          }
          .id("Now Playing")
          .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
          
          Group {
            if upcomingState.movies != nil {
              MovieBackdropCarouselView(title: "Upcoming", movies: upcomingState.movies!)
            } else {
              LoadingView(isLoading: self.upcomingState.isLoading, error: self.upcomingState.error) {
                self.upcomingState.loadMovies(with: .upcoming)
              }
            }
          }
          .id("Upcoming")
          .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
          
          Group {
            if topRatedState.movies != nil {
              MovieBackdropCarouselView(title: "Top Rated", movies: topRatedState.movies!)
            } else {
              LoadingView(isLoading: self.topRatedState.isLoading, error: self.topRatedState.error) {
                self.topRatedState.loadMovies(with: .topRated)
              }
            }
          }
          .id("Top Rated")
          .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
          
          Group {
            if popularState.movies != nil {
              MovieBackdropCarouselView(title: "Popular", movies: popularState.movies!)
            } else {
              LoadingView(isLoading: self.popularState.isLoading, error: self.popularState.error) {
                self.popularState.loadMovies(with: .popular)
              }
            }
          }
          .id("Popular")
          .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
          
        }
        .navigationBarTitle("The MovieDB")
        .onChange(of: appController.selectedType) { selectedType in
          if selectedType != nil {
            scrollViewProxy.scrollTo(selectedType)
          }
        }
      }
    }
    .onAppear {
//      self.nowPlayingState.loadMovies(with: .nowPlaying)
//      self.upcomingState.loadMovies(with: .upcoming)
//      self.topRatedState.loadMovies(with: .topRated)
//      self.popularState.loadMovies(with: .popular)
      self.nowPlayingState.movies = Movie.stubbedMovies
      self.upcomingState.movies = Movie.stubbedMovies
      self.topRatedState.movies = Movie.stubbedMovies
      self.popularState.movies = Movie.stubbedMovies
      
      do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let nowPlayingJsonData = try encoder.encode(nowPlayingState.movies)
        let nowPlayingJsonObject = try JSONSerialization.jsonObject(with: nowPlayingJsonData, options: [])

        let upcomingJsonData = try encoder.encode(upcomingState.movies)
        let upcomingJsonObject = try JSONSerialization.jsonObject(with: upcomingJsonData, options: [])
        
        let topRatedJsonData = try encoder.encode(upcomingState.movies)
        let topRatedJsonObject = try JSONSerialization.jsonObject(with: upcomingJsonData, options: [])
        
        let popularJsonData = try encoder.encode(upcomingState.movies)
        let popularJsonObject = try JSONSerialization.jsonObject(with: upcomingJsonData, options: [])
        
        self.alanManager.sendVisual(["nowPlaying": nowPlayingJsonObject,
                                     "upcoming": upcomingJsonObject,
                                     "topRated": topRatedJsonObject,
                                     "popular": popularJsonObject])
      } catch {
        self.alanManager.sendVisual(["erro": ["Erro ao recuperar dados"]])
      }
      
    }
  }
}

struct MovieListView_Previews: PreviewProvider {
  static var previews: some View {
    MovieListView()
  }
}
