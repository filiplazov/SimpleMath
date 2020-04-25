//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct ResultsHeaderView: View {
  let correctAnswers: Int
  let wrongAnswers: Int

  var body: some View {
    HStack {
      Text(correctAnswers.description)
      Image(withSymbol: .star)
      .font(Font.system(size: 30, weight: .bold, design: .monospaced))
      if wrongAnswers > 0 {
        Text(wrongAnswers.description)
          .padding(.leading, 10)
          .foregroundColor(.incorrectAnswer)
        Text("😞")
      }
      Spacer()
    }
    .font(Font.system(size: 34, weight: .bold, design: .monospaced))
    .foregroundColor(.correctAnswer)
  }
}
