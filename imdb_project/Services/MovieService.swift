//
//  MovieService.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import Foundation

protocol MovieService {
  
}

enum MovieListEndpoint: String {
  case nowPlaying = "now_playing"
  case upcoming
  case topRated = "top_rated"
  case popular
  
  var description: String {
    switch self {
      case .nowPlaying return "Now Playing"
    }
  }
}
