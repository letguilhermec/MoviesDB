//
//  TextExtensions.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 29/05/23.
//

import SwiftUI

extension Text {
  func scalableText(font: Font = Font.system(size: 1000)) -> some View {
    self
      .font(font)
      .minimumScaleFactor(0.01)
      .lineLimit(1)
  }
}
