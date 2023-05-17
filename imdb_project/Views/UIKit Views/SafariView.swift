//
//  SafariView.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 17/05/23.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
  let url: URL
  
  func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    
  }
  
  func makeUIViewController(context: Context) -> SFSafariViewController {
    let safariVC = SFSafariViewController(url: self.url)
    return safariVC
  }
}
