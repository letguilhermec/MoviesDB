//
//  MovieBackdropCarouselView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI

struct MovieBackdropCarouselView: View {
  let title: String
  let movies: [Movie]
  @StateObject private var appController = AppController.shared

  var body: some View {
    
    
    VStack(alignment: .leading, spacing: 0) {
      
      Text(title)
        .font(.title)
        .fontWeight(.bold)
        .padding(.horizontal)
      
      ScrollViewReader { scrollViewProxy in
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(alignment: .top, spacing: 16) {
            ForEach(self.movies) { movie in
              NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                MovieBackdropCard(movie: movie)
                  .frame(width: 272, height: 200)
                  .overlay {
                    RoundedRectangle(cornerRadius: 8)
                      .stroke(appController.selectedIndice == movie.id ? Color.blue : Color.clear, lineWidth: 8)
                  }
                  .id(movie.id)
              }
              .buttonStyle(PlainButtonStyle())
              .padding(.leading, movie.id == self.movies.first!.id ? 16 : 0)
              .padding(.trailing, movie.id == self.movies.last!.id ? 16 : 0)
              .onChange(of: appController.selectedIndice) { selectedIndice in
                if appController.selectedType == title && selectedIndice == movie.id {
                  scrollViewProxy.scrollTo(movie.id, anchor: .center)
                }
              }
            }
          }
        }
      }
    }
    .background(appController.selectedType == title ? Color.accentColor.opacity(0.15) : Color.clear)
  }
}

struct MovieBackdropCarouselView_Previews: PreviewProvider {
  static var previews: some View {
    MovieBackdropCarouselView(title: "Upcoming", movies: Movie.stubbedMovies)
  }
}
