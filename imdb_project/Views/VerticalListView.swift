//
//  UpcomingView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 19/05/23.
//

import SwiftUI

struct VerticalListView: View {
  let title: String
  let movies: [Movie]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(title)
        .font(.title)
        .fontWeight(.bold)
        .padding()
      
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .center, spacing: 16) {
          ForEach(self.movies) { movie in
            NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
              MovieBackdropCard(movie: movie)
                .padding(.horizontal)
            }
            .buttonStyle(PlainButtonStyle())
              .padding(.top, movie.id == self.movies.first!.id ? 16 : 0)
              .padding(.bottom, movie.id == self.movies.last!.id ? 16 : 0)
          }
        }
      }
    }
  }
}

struct UpcomingView_Previews: PreviewProvider {
  static var previews: some View {
    VerticalListView(title: "Upcoming", movies: Movie.stubbedMovies)
  }
}
