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
  @EnvironmentObject private var appController: AppController
  @StateObject private var imageLoader = ImageLoader()
  @State private var backdropImages: [Int: UIImage] = [:]
  let alanManager = UIApplication.shared
  @Binding var isShown: Bool

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
              createMovieBackdropCard(movie: movie, scrollViewProxy: scrollViewProxy)
            }
          }
        }
      }
      .background(appController.selectedType == title ? Color.accentColor.opacity(0.15) : Color.clear)
      .onAppear {
        loadBackdropImages()
        
        var alanTitle = ""
        switch title {
        case "Upcoming":
          alanTitle = "upcoming"
        case "Top Rated":
          alanTitle = "topRated"
        case "Popular":
          alanTitle = "popular"
        default:
          return
        }
        
        do {
          let encoder = JSONEncoder()
          encoder.outputFormatting = .prettyPrinted
          
          let encodedMovies = try encoder.encode(self.movies)
          let jsonMovies = try JSONSerialization.jsonObject(with: encodedMovies, options: [])
          
          alanManager.call(method: "script::setMovieList", params: [alanTitle: jsonMovies]) { (error, result) in }
          
        } catch {
          print("ERRO: ", error)
        }
      }
    }
  }
    
    func createMovieBackdropCard(movie: Movie, scrollViewProxy: ScrollViewProxy) -> some View {
      let image = backdropImages[movie.id]

      return Button {
        appController.showingMovieId = movie.id
        appController.isShowingMovieDetails = true
      } label: {
        MovieBackdropCard(movie: movie, image: image)
          .frame(width: 272, height: 200)
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
        if appController.selectedType == title && selectedIndice == movie.id {
          scrollViewProxy.scrollTo(movie.id, anchor: .center)
        } else if appController.selectedType == title && selectedIndice == -1 {
          scrollViewProxy.scrollTo(movies[0].id, anchor: .center)
        }
      }
    }
    
    func loadBackdropImages() {
      for movie in movies {
        imageLoader.loadImage(with: movie.backdropURL, movieID: movie.id) { image, movieID in
          if let image = image {
            DispatchQueue.main.async {
              backdropImages[movieID] = image
            }
          }
        }
      }
    }
}

struct MovieBackdropCarouselView_Previews: PreviewProvider {
  static var previews: some View {
    MovieBackdropCarouselView(title: "Upcoming", movies: Movie.stubbedMovies, isShown: .constant(false))
      .environmentObject(AppController.shared)
  }
}
