//
//  ActivityIndicatorView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    <#code#>
  }
  
  func makeUIView(context: Context) -> UIActivityIndicatorView {
    let view = UIActivityIndicatorView(style: .large)
    view.startAnimating()
    return view
  }
}
