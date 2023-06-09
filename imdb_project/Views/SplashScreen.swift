//
//  SplashScreen.swift
//  imdb_project
//
//  Created by Guilherme de Carvalho Correa on 29/05/23.
//

import SwiftUI

struct SplashScreen: View {
  func banner(text: String, color: String, width: CGFloat) -> some View {
    ZStack {
      Text(text)
        .fontWeight(.bold)
        .scalableText()
        .foregroundColor(Color(color))
        .padding(.horizontal, 30)
        .frame(width: width)
    }
  }
  
  var body: some View {
    ZStack {
      Color("background")
        .ignoresSafeArea()
      banner(text: "DB", color: "appColor6", width: 405)
        .splashAnimation(finalYPosition: 140, delay: 0)
      banner(text: "Movie", color: "appColor5", width: 405)
        .splashAnimation(finalYPosition: 0, delay: 0.2)
      banner(text: "THE", color: "appColor5", width: 200)
        .splashAnimation(finalYPosition: -80, delay: 0.4)
        .offset(x: -100)
    }
  }
}

private struct SplashAnimation: ViewModifier {
  @State private var animating = true
  let finalYPosition: CGFloat
  let delay: Double
  
  let animation = Animation.interpolatingSpring(
    mass: 0.2,
    stiffness: 80,
    damping: 5,
    initialVelocity: 0.0)
  
  func body(content: Content) -> some View {
    content
      .offset(y: animating ? -700 : finalYPosition)
      .animation(animation.delay(delay), value: animating)
      .onAppear {
        animating = false
      }
  }
}

private extension View {
  func splashAnimation(
    finalYPosition: CGFloat,
    delay: Double
  ) -> some View {
    modifier(SplashAnimation(
      finalYPosition: finalYPosition,
      delay: delay))
  }
}

struct SplashScreen_Previews: PreviewProvider {
  static var previews: some View {
    SplashScreen()
  }
}
