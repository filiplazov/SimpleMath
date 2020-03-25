//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct GreatSuccessOverlayView: View {
  @State private var scale: CGFloat = 1.0
  @State private var angle: Double = 0
  
  var body: some View {
    ZStack {
      Text("🤩")
        .font(Font.system(size: 260, weight: .bold, design: .default))
      StarView(xOffset: -240, yOffset: 0, scale: scale, angle: angle)
      StarView(xOffset: -180, yOffset: 180, scale: scale, angle: angle)
      StarView(xOffset: 0, yOffset: 240, scale: scale, angle: angle)
      StarView(xOffset: 180, yOffset: 180, scale: scale, angle: angle)
      StarView(xOffset: 240, yOffset: 0, scale: scale, angle: angle)
      StarView(xOffset: 180, yOffset: -180, scale: scale, angle: angle)
      StarView(xOffset: 0, yOffset: -240, scale: scale, angle: angle)
      StarView(xOffset: -180, yOffset: -180, scale: scale, angle: angle)
    }
    .onAppear {
      withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
        self.scale = self.scale == 1 ? 0.7 : 1.0
        self.angle = self.angle == 360.0 ? 0 : 360
      }
    }
  }
}

private struct StarView: View {
  let xOffset: CGFloat
  let yOffset: CGFloat
  let scale: CGFloat
  let angle: Double
  
  var body: some View {
    Image(systemName: Symbol.star.rawValue)
      .font(Font.system(size: 100, weight: .bold, design: .default))
      .foregroundColor(Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)))
      .scaleEffect(scale)
      .rotationEffect(.degrees(angle))
      .offset(x: xOffset, y: yOffset)
  }
}
