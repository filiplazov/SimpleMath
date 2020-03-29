//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct ProgressView: View {
  let width: CGFloat
  let strokeWidth: CGFloat
  let progress: Double
  let circleSize: CGFloat
  
  init(width: CGFloat, progress: Double) {
    self.width = width
    self.progress = progress
    let strokeScale: CGFloat = 0.13
    circleSize = width / ( 1 + strokeScale)
    strokeWidth = circleSize * strokeScale
  }
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: strokeWidth)
        .frame(width: circleSize, height: circleSize)
        .foregroundColor(Color(#colorLiteral(red: 0.3870187126, green: 0.08371740527, blue: 0.3813446013, alpha: 1)))
      Circle()
        .trim(from: CGFloat(1 - progress), to: 1)
        .stroke(lineWidth: strokeWidth)
        .rotationEffect(.degrees(90))
        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
        .frame(width: circleSize, height: circleSize)
        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.7))
    }
      
    .frame(width: width, height: width)
    .opacity(progress > 0 ? 1.0 : 0.0)
  }
}
