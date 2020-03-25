//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import CornerStacks
import SwiftUI

struct CorrectAnswersView: View {
  let correctAnswers: Int

  var body: some View {
    TopTrailingVStack(spacing: 10) {
      Text(self.correctAnswers.description)
        .font(Font.system(size: 70, weight: .bold, design: .monospaced))
        .padding([.top, .trailing], 30)
      
      Image(systemName: Symbol.star.rawValue)
        .font(Font.system(size: 50, weight: .bold, design: .monospaced))
        .padding([.trailing], 22)
    }
    .opacity(correctAnswers > 0 ? 1 : 0)
    .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
  }
  

}
