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
  @EnvironmentObject private var appController: AppController
  @StateObject private var imageLoader = ImageLoader()
  @State private var posterImages: [Int: UIImage] = [:]
  @Binding var isShown: Bool
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
              createMoviePosterCard(movie: movie, scrollViewProxy: scrollViewProxy)
            }
          }
        }
      }
    }
    .padding(.vertical)
    .background(appController.selectedType == title ? Color.accentColor.opacity(0.15) : Color.clear)
    .onAppear {
      
      loadPosterImages()
      
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
  
  
  @ViewBuilder
  func createMoviePosterCard(movie: Movie, scrollViewProxy: ScrollViewProxy) -> some View {
    let image = posterImages[movie.id]
    
    Button {
      appController.showingMovieId = movie.id
      appController.isShowingMovieDetails = true
    } label: {
      MoviePosterCard(movie: movie, image: image)
        .overlay {
          RoundedRectangle(cornerRadius: 8)
            .stroke(appController.selectedIndice == movie.id ? Color.blue : Color.clear, lineWidth: 4)
        }
        .id(movie.id)
    }
    .buttonStyle(PlainButtonStyle())
    .padding(.leading, movie.id == self.movies.first!.id ? 16 : 0)
    .padding(.trailing, movie.id == self.movies.last!.id ? 16 : 0)
    .onChange(of: appController.selectedIndice) { selectedIndice in
      if appController.selectedType == "Now Playing" && selectedIndice == movie.id {
        scrollViewProxy.scrollTo(movie.id, anchor: .center)
      } else if selectedIndice == -1 {
        scrollViewProxy.scrollTo(self.movies.first?.id, anchor: .center)
      }
    }
  }
  
  func loadPosterImages() {
    for movie in movies {
      imageLoader.loadImage(with: movie.posterURL, movieID: movie.id) { image, movieID in
        if let image = image {
          DispatchQueue.main.async {
            posterImages[movieID] = image
          }
        }
      }
    }
  }
  
}

struct MoviePosterCarouselView_Previews: PreviewProvider {
  static var previews: some View {
    MoviePosterCarouselView(title: "Now Playing", movies: Movie.stubbedMovies, isShown: .constant(false))
      .environmentObject(AppController.shared)
  }
}
