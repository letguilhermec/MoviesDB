//
//  Movie.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import Foundation

struct MovieResponse: Decodable {
  
  let results: [Movie]
}


struct Movie: Decodable {
  
  let id: Int
  let title: String
  let backdropPath: String?
  let posterPath: String?
  let overview: String
  let voteAverage: Double
  let voteCount: Int
  let runtime: Int?
  
}
