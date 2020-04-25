//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct GreatSuccessOverlayView: View {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  @State private var scale: CGFloat = 1.0
  @State private var angle: Double = 0
  private var axisOffset: CGFloat { hSizeClass.isRegular ? 240 : 120 }
  private var diagonalOffset: CGFloat { hSizeClass.isRegular ? 180 : 90 }

  var body: some View {
    ZStack {
      Text("🤩")
        .font(Font.system(size: self.hSizeClass.isRegular ? 260 : 130, weight: .bold, design: .default))
      StarView(xOffset: -axisOffset, yOffset: 0, scale: scale, angle: angle)
      StarView(xOffset: -diagonalOffset, yOffset: diagonalOffset, scale: scale, angle: angle)
      StarView(xOffset: 0, yOffset: axisOffset, scale: scale, angle: angle)
      StarView(xOffset: diagonalOffset, yOffset: diagonalOffset, scale: scale, angle: angle)
      StarView(xOffset: axisOffset, yOffset: 0, scale: scale, angle: angle)
      StarView(xOffset: diagonalOffset, yOffset: -diagonalOffset, scale: scale, angle: angle)
      StarView(xOffset: 0, yOffset: -axisOffset, scale: scale, angle: angle)
      StarView(xOffset: -diagonalOffset, yOffset: -diagonalOffset, scale: scale, angle: angle)
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
  @Environment(\.horizontalSizeClass) private var hSizeClass
  let xOffset: CGFloat
  let yOffset: CGFloat
  let scale: CGFloat
  let angle: Double

  var body: some View {
    Image(withSymbol: .star)
      .font(Font.system(size: hSizeClass.isRegular ? 100 : 50, weight: .bold, design: .default))
      .foregroundColor(.yellowStar)
      .scaleEffect(scale)
      .rotationEffect(.degrees(angle))
      .offset(x: xOffset, y: yOffset)
  }
}
