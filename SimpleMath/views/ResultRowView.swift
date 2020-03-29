//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct ResultRowView: View {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  let equation: Equation
  
  var body: some View {
    HStack() {
      Text(equation.question)
        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
      Text(" \(equation.currentAnswerText)")
        .foregroundColor(equation.correctlyAnswered ? Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)) : Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)))
        .strikethrough(!equation.correctlyAnswered, color: Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)))
      if !equation.correctlyAnswered {
        Text(equation.correctAnswer.description)
          .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
      }
    }
    .font(Font.system(size: self.hSizeClass.isRegular ? 34 : 26, weight: .heavy, design: .monospaced))
  }
}
