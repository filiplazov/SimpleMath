//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct ProgressView: View {
  private let width: CGFloat = 60
  let progress: Double
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: 10)
        .frame(width: width, height: width)
        .foregroundColor(Color(#colorLiteral(red: 0.3870187126, green: 0.08371740527, blue: 0.3813446013, alpha: 1)))
      Circle()
        .trim(from: CGFloat(1 - progress), to: 1)
        .stroke(lineWidth: 10)
        .rotationEffect(.degrees(90))
        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
        .frame(width: width, height: width)
        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.7))
    }
    .opacity(progress > 0 ? 1.0 : 0.0)
    .padding(.top, 50)
    .padding(.leading, 22)
  }
}
