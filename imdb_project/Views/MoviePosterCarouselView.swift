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
  let alanManager = UIApplication.shared
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(title)
        .font(.title)
        .fontWeight(.bold)
        .padding(.horizontal)
      ScrollViewReader { scrollViewProxy in
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(alignment: .top, spacing: 16) {
            ForEach(self.movies) { movie in
              NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                MoviePosterCard(movie: movie)
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
                  if appController.selectedType == "Now Playing" && selectedIndice == movie.id {
                    scrollViewProxy.scrollTo(movie.id, anchor: .center)
                  }
                }
            }
          }
        }
      }
    }
    .background(appController.selectedType == title ? Color.accentColor.opacity(0.15) : Color.clear)
    .onAppear {
      
      do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedMovies = try encoder.encode(self.movies)
        let nowPlayingJsonObject = try JSONSerialization.jsonObject(with: encodedMovies, options: [])
        
        alanManager.call(method: "script::setMovieList", params: ["nowPlaying": nowPlayingJsonObject]) { (error, result) in }
        
      } catch {
        print("ERRO: ", error)
      }
    }
  }
}

struct MoviePosterCarouselView_Previews: PreviewProvider {
  static var previews: some View {
    MoviePosterCarouselView(title: "Now Playing", movies: Movie.stubbedMovies)
  }
}
