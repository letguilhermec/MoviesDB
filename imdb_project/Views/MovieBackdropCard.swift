//
//  MovieBackdropCard.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI

struct MovieBackdropCard: View {
  let movie: Movie
  let image: UIImage?
  
  var body: some View {
    VStack(alignment: .leading) {
      ZStack {
        Rectangle()
          .fill(Color.gray.opacity(0.3))
        if let image = image {
          Image(uiImage: image)
            .resizable()
        }
      }
      .aspectRatio(16/9, contentMode: .fit)
      .cornerRadius(8)
      .shadow(radius: 4)
      Text(movie.title)
        .lineLimit(1)
    }
  }
}

struct MovieBackdropCard_Previews: PreviewProvider {
  static var previews: some View {
    MovieBackdropCard(movie: Movie.stubbedMovie, image: nil)
  }
}
