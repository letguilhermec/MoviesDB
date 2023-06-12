//
//  Alan+UIApplication.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 18/05/23.
//

import UIKit
import AlanSDK

extension UIApplication {
  
  // MARK: - Vars
  
  /// Alan button variable association (store var in extension)
  private static let associationAlanButton = ObjectAssociation<AlanButton>()
  
  /// Alan button variable
  var alanButton: AlanButton? {
    get { return UIApplication.associationAlanButton[self] }
    set { UIApplication.associationAlanButton[self] = newValue }
  }
  
  /// Alan text box variable association (store var in extension)
  private static let associationAlanText = ObjectAssociation<AlanText>()
  
  /// Alan text box variable
  var alanText: AlanText? {
    get { return UIApplication.associationAlanText[self] }
    set { UIApplication.associationAlanText[self] = newValue }
  }
  
  // MARK: - Actions
  
  /// Add button
  func addAlan() {
    self.setupButton()
    self.setupText()
    self.setupHandlers()
    self.setupLogs()
  }
  
  /// Send visual state via Alan button
  func sendVisual(_ data: [String: Any]) {
    if let button = self.alanButton {
      button.setVisualState(data)
    }
  }
  
  /// Play text via Alan button
  func playText(_ text: String) {
    if let button = self.alanButton {
      button.playText(text)
    }
  }
  
  /// Play data via Alan button
  func playData(_ data: [String: String]) {
    if let button = self.alanButton {
      button.playCommand(data)
    }
  }
  
  /// Call method via Alan button
  func call(method: String, params: [String: Any], callback:@escaping ((Error?, String?) -> Void)) {
    if let button = self.alanButton {
      button.callProjectApi(method, withData: params, callback: callback)
    }
  }
  
  
  // MARK: - Helpers
  
  fileprivate func getRoot() -> UIViewController? {
    guard let window = UIApplication.shared.windows.first else {
      return nil
    }
    guard let root = window.rootViewController else {
      return nil
    }
    return root
  }
  
  
  // MARK: - Setup
  
  fileprivate func setupLogs() {
    /// Set to true to show all Alan SDK logs
    AlanLog.setEnableLogging(true)
  }
  
  fileprivate func setupButton() {
    guard let root = self.getRoot() else {
      return
    }
    guard let view = root.view else {
      return
    }
    
    // prepare config object with project key
    let config = AlanConfig(key: "a0820163c2b99d0fa17017f605aa8e222e956eca572e1d8b807a3e2338fdd0dc/stage")
    
    // create Alan button with config
    self.alanButton = AlanButton(config: config)
    
    /// check Alan button
    guard let button = self.alanButton else {
      return
    }
    
    // align button on view
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    let b = NSLayoutConstraint(item: button as Any, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -100)
    let r = NSLayoutConstraint(item: button as Any, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -10)
    let w = NSLayoutConstraint(item: button as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
    let h = NSLayoutConstraint(item: button as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
    view.addConstraints([b, r, w, h])
    view.bringSubviewToFront(button)
  }
  
  fileprivate func setupText() {
    guard let root = self.getRoot() else {
      return
    }
    guard let view = root.view else {
      return
    }
    
    // create text box
    self.alanText = AlanText(frame: CGRect.zero)
    
    /// check Alan button
    guard let text = self.alanText else {
      return
    }
    
    // align text on view
    text.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(text)
    let b = NSLayoutConstraint(item: text as Any, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -100)
    let l = NSLayoutConstraint(item: text as Any, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 10)
    let r = NSLayoutConstraint(item: text as Any, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20)
    let h = NSLayoutConstraint(item: text as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
    view.addConstraints([b, r, l, h])
    view.bringSubviewToFront(text)
  }
  
  fileprivate func setupHandlers() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleAlanEvent(_:)), name: .handleEvent, object:nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleAlanState(_:)), name: .handleState, object:nil)
  }
  
  
  // MARK: - Handlers
  
  @objc func handleAlanState(_ notification: Notification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    guard let value = userInfo["onButtonState"] as? Int else {
      return
    }
    guard let state = AlanSDKButtonState(rawValue: value) else {
      return
    }
    switch state {
    case .online:
      print("Connected")
      break
    default:
      break
    }
  }
  
  @objc func handleAlanEvent(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let event = userInfo["onEvent"] as? String,
          event == "command",
          let jsonString = userInfo["jsonString"] as? String,
          let data = jsonString.data(using: .utf8),
          let unwrapped = try? JSONSerialization.jsonObject(with: data, options: []),
          let d = unwrapped as? [String: Any],
          let json = d["data"] as? [String: Any],
          let command = json["command"] as? String
    else {
      return
    }
    
    if command == "printTest" {
      DispatchQueue.main.async {
        self.printTest()
      }
    } else if command == "nilType" {
      AppController.shared.selectedType = nil
    } else if command == "nilMovie" {
      AppController.shared.selectedMovie = nil
    } else if command == "nilSearchTitle" {
      AppController.shared.searchQuery = ""
    } else if command == "nowPlayingMovies" {
      AppController.shared.isSearching = false
      AppController.shared.selectedType = "Now Playing"
    } else if command == "upcomingMovies" {
      AppController.shared.isSearching = false
      AppController.shared.selectedType = "Upcoming"
    } else if command == "popularMovies" {
      AppController.shared.isSearching = false
      AppController.shared.selectedType = "Popular"
    } else if command == "topRatedMovies" {
      AppController.shared.isSearching = false
      AppController.shared.selectedType = "Top Rated"
    } else if command == "highlight" {
      AppController.shared.selectedIndice = json["data"] as? Int ?? 0
    } else if command == "zeroIndex" {
      AppController.shared.selectedIndice = -1
    } else if command == "openMovie" {
      AppController.shared.isShowingMovieDetails = true
      AppController.shared.showingMovieId = json["data"] as? Int ?? nil
    } else if command == "closeMovie" {
      AppController.shared.isShowingMovieDetails = false
    } else if command == "openSearch" {
      AppController.shared.searchQuery = json["data"] as? String ?? ""
      AppController.shared.isSearching = true
    } else if command == "openHome" {
      AppController.shared.isSearching = false
    }

  }
  
  
  // MARK: - Commands
  
  fileprivate func printTest() {
    print("teste")
  }
  
}


public final class ObjectAssociation<T: AnyObject> {
  
  private let policy: objc_AssociationPolicy
  
  /// - Parameter policy: An association policy that will be used when linking objects.
  public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
    
    self.policy = policy
  }
  
  /// Accesses associated object.
  /// - Parameter index: An object whose associated object is to be accessed.
  public subscript(index: AnyObject) -> T? {
    
    get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
    set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
  }
}

extension Notification.Name {
  static let handleEvent = Notification.Name("kAlanSDKEventNotification")
  static let handleState = Notification.Name("kAlanSDKAlanButtonStateNotification")
}
