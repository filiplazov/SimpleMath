//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info/

import SwiftUI

struct PlayPauseView: View {
  private let shorterSize: CGFloat
  private let longerSize: CGFloat
  var play: Bool
  let width: CGFloat
  

  init(play: Bool, width: CGFloat) {
    self.play = play
    self.width = width
    shorterSize = width * 0.2
    longerSize = width * 0.8
  }
  
  
  var body: some View {
    ZStack {
      Tetragon(p1: CGPoint(x: play ? 1 : 0, y: 0), animateOn: \.p1.x)
        .frame(width: shorterSize, height: longerSize)
        .scaleEffect(CGSize(width: play ? 2 : 1, height: 1))
        .offset(x: -shorterSize, y: 0)

      Tetragon(p2: CGPoint(x: play ? 0 : 1, y: 0), animateOn: \.p2.x)
        .frame(width: shorterSize, height: longerSize)
        .scaleEffect(CGSize(width: play ? 2 : 1, height: 1))
        .offset(x: shorterSize, y: 0)
        
    }
    .frame(width: width, height: width)
    .rotationEffect(.degrees( play ? 90 : 0))
    .animation(Animation.spring())
  }
}

struct PlayPauseView_Previews: PreviewProvider {
  static var previews: some View {
    PlayPauseView(play: false, width: 300)
      .frame(width: 400, height: 400)
  }
}

struct Tetragon : Shape {
  typealias AnimatableData = CGFloat
  
  var p0, p1, p2, p3: CGPoint
  var animateOn: WritableKeyPath<Tetragon, CGFloat>
  
  internal init(
    p0: CGPoint = .init(x: 0, y: 1),
    p1: CGPoint = .init(x: 0, y: 0),
    p2: CGPoint = .init(x: 1, y: 0),
    p3: CGPoint = .init(x: 1, y: 1),
    animateOn: WritableKeyPath<Tetragon, CGFloat>) {
    self.p0 = p0
    self.p1 = p1
    self.p2 = p2
    self.p3 = p3
    self.animateOn = animateOn
  }
  
  var animatableData: CGFloat {
    get { self[keyPath: animateOn] }
    set { self[keyPath: animateOn] = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    Path { p in
      p.move(to: CGPoint(x: p0.x * rect.size.width, y: p0.y * rect.size.height))
      p.addLine(to: CGPoint(x: p1.x * rect.size.width, y: p1.y * rect.size.height))
      p.addLine(to: CGPoint(x: p2.x * rect.size.width, y: p2.y * rect.size.height))
      p.addLine(to: CGPoint(x: p3.x * rect.size.width, y: p3.y * rect.size.height))
      p.addLine(to: CGPoint(x: p0.x * rect.size.width, y: p0.y * rect.size.height))
    }
  }
}
