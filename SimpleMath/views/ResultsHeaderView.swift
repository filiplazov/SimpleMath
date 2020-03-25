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
      Image(systemName: "star.fill")
      .font(Font.system(size: 30, weight: .bold, design: .monospaced))
      if wrongAnswers > 0 {
        Text(wrongAnswers.description)
          .padding(.leading, 10)
          .foregroundColor(Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)))
        Text("😞")
      }
      Spacer()
    }
    .font(Font.system(size: 34, weight: .bold, design: .monospaced))
    .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
  }
}
