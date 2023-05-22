//
//  AppController.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 22/05/23.
//

import SwiftUI

class AppController: ObservableObject {
  static let shared = AppController()
  
  var isNowOpen: Bool = false
  var isUpcomingOpen: Bool = false
  var isPopularOpen: Bool = false
  var isTopRatedOpen: Bool = false
  var isSearchOpen: Bool = false
  
  private init() {}
}
