//
//  MoviePosterCard.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI

struct MoviePosterCard: View {
  let movie: Movie
  let image: UIImage?
  
  var body: some View {
    ZStack {
      if let image = image {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(8)
          .shadow(radius: 4)
      } else {
        Rectangle()
          .fill(Color.gray.opacity(0.3))
          .cornerRadius(8)
          .shadow(radius: 4)
        Text(movie.title)
          .multilineTextAlignment(.center)
      }
    }
    .frame(width: 204, height: 306)
  }
}

struct MoviePosterCard_Previews: PreviewProvider {
  static var previews: some View {
    MoviePosterCard(movie: Movie.stubbedMovie, image: nil)
  }
}
