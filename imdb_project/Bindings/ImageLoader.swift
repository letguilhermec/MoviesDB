//
//  ImageLoader.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 16/05/23.
//

import SwiftUI
import UIKit

private let _imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: ObservableObject {
  @Published var image: UIImage?
  @Published var isLoading = false
  @Published var posterImages: [Int: UIImage] = [:]
  
  var imageCache = _imageCache
  
  func loadImage(with url: URL) {
    let urlString = url.absoluteString
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
      self.image = imageFromCache
      return
    }
    
    DispatchQueue.global(qos: .background).async { [weak self] in
      guard let self = self else { return }
      do {
        let data = try Data(contentsOf: url)
        guard let image = UIImage(data: data) else {
          return
        }
        self.imageCache.setObject(image, forKey: urlString as AnyObject)
        DispatchQueue.main.async { [weak self] in
          self?.image = image
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func loadImage(with url: URL, movieID: Int, completion: @escaping (UIImage?, Int) -> Void) {
    let urlString = url.absoluteString
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
      completion(imageFromCache, movieID)
      return
    }
    
    DispatchQueue.global(qos: .background).async {
      do {
        let data = try Data(contentsOf: url)
        guard let image = UIImage(data: data) else {
          completion(nil, movieID)
          return
        }
        self.imageCache.setObject(image, forKey: urlString as AnyObject)
        completion(image, movieID)
      } catch {
        print(error.localizedDescription)
        completion(nil, movieID)
      }
    }
  }
}
