//
//  MoviePosterCarouselView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI

struct MoviePosterCarouselView: View {
  let title: String
  let movies: [Movie]
  @StateObject private var appController = AppController.shared
  
  var isNowOpen: Binding<Bool> {
    Binding<Bool>(
      get: { self.appController.isNowOpen },
      set: { self.appController.isNowOpen = $0 }
    )
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      NavigationLink(destination: VerticalListView(title: title, movies: movies), isActive: isNowOpen) {
        Text(title)
          .font(.title)
          .fontWeight(.bold)
        .padding(.horizontal)
      }
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top, spacing: 16) {
          ForEach(self.movies) { movie in
            NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
              MoviePosterCard(movie: movie)
            }
              .buttonStyle(PlainButtonStyle())
              .padding(.leading, movie.id == self.movies.first!.id ? 16 : 0)
              .padding(.trailing, movie.id == self.movies.last!.id ? 16 : 0)
          }
        }
      }
    }
  }
}

struct MoviePosterCarouselView_Previews: PreviewProvider {
  static var previews: some View {
    MoviePosterCarouselView(title: "Now Playing", movies: Movie.stubbedMovies)
  }
}
