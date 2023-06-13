//
//  AppController.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 22/05/23.
//

import SwiftUI

class AppController: ObservableObject, Equatable {
  
  static func == (lhs: AppController, rhs: AppController) -> Bool {
    return lhs.searchQuery == rhs.searchQuery
  }
  
  static let shared = AppController()
  
  @Published var isShowingMovieDetails: Bool = false
  @Published var showingMovieId: Int? = 0
  @Published var selectedIndice: Int? = 0
  @Published var selectedType: String? = nil
  @Published var selectedMovie: [Movie]? = nil
  @Published var isSearching: Bool = false
  @Published var searchQuery: String? = nil
  
  private init() {}
}
