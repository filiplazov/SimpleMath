//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct ResultRowView: View {
  let equation: Equation
  
  var body: some View {
    HStack() {
      Text(equation.question)
        .foregroundColor(.primaryText)
      Text(equation.currentAnswerText)
        .foregroundColor(equation.correctlyAnswered ? .correctAnswer : .incorrectAnswer)
        .strikethrough(!equation.correctlyAnswered, color: .incorrectAnswer)
      if !equation.correctlyAnswered {
        Text(equation.correctAnswer.description)
          .foregroundColor(.correctAnswer)
      }
    }
  }
}
