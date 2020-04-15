//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct ProgressView: View {
  private var play: Bool
  private let width: CGFloat
  private let strokeWidth: CGFloat
  private let progress: Double
  private let circleSize: CGFloat
  private let pulse: Bool
  private let action: () -> Void
  @State private var pulseFactor: CGFloat = 0
  
  init(width: CGFloat, progress: Double, play: Bool, pulse: Bool, action: @escaping () -> Void) {
    self.width = width
    self.progress = progress
    self.play = play
    self.pulse = pulse
    self.action = action
    let strokeScale: CGFloat = 0.13
    circleSize = width / ( 1 + strokeScale)
    strokeWidth = circleSize * strokeScale
  }
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: strokeWidth)
        .frame(width: circleSize, height: circleSize)
        .foregroundColor(.progressIncomplete)
      Circle()
        .trim(from: CGFloat(1 - progress), to: 1)
        .stroke(lineWidth: strokeWidth)
        .rotationEffect(.degrees(90))
        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
        
        .frame(width: circleSize, height: circleSize)
        .foregroundColor(Color.progressComplete.opacity(0.7))
      PlayPauseView(play: play, width: width * 0.5)
        .foregroundColor(.playPause)
    }
      
    .frame(width: width, height: width)
    .anchorPreference(key: BoundsAnchorKey.self, value: .bounds, transform: { $0 })
    .backgroundPreferenceValue(BoundsAnchorKey.self) { anchor in
      if self.pulse {
        GeometryReader { proxy in
          Circle()
            .stroke(lineWidth: 2)
            .foregroundColor(Color.primaryText.opacity(Double(1 - self.pulseFactor) * 0.4))
            .scaleEffect(0.9)
            .scaleEffect(self.pulseFactor + 1)
            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
            .offset(x: proxy[anchor!].minX, y: proxy[anchor!].minY)
        }
      }
    }
    .onAppear { self.pulseFactor = 1 }
    .animation(.spring())
    .onTapGesture {
      withAnimation {
        self.action()
      }
    }
  }
}


