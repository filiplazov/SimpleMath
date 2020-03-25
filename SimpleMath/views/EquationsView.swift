//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct EquationsView: View {
  @ObservedObject var viewModel: SimpleMathViewModel
  
  var body: some View {
    ZStack {
      ForEach(viewModel.equations.indices, id: \.self) { index in
        EquationRowView(equation: self.viewModel.equations[index], isCurrentEquation: self.viewModel.currentEquationIndex == index)
          .offset(x: 0, y: self.verticalOffset(forIndex: index))
          .opacity(self.opacity(forIndex: index))
      }
      
    }
    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
    .font(Font.system(size: 70, weight: .bold, design: .monospaced))
  }
  
  private func verticalOffset(forIndex index: Int) -> CGFloat {
    if index == viewModel.currentEquationIndex {
      return 240
    } else {
      return CGFloat(240.0 + Double((index - viewModel.currentEquationIndex)) * 100.0)
    }
  }
  
  private func opacity(forIndex index: Int) -> Double {
    let distance = abs(index - viewModel.currentEquationIndex)
    switch distance {
    case 0: return 1
    case 1: return 0.5
    case 2: return 0.3
    default: return 0
    }
  }
}

private struct EquationRowView: View {
  let equation: Equation
  let isCurrentEquation: Bool
  
  var body: some View {
    HStack {
      Text(equation.question)
      Text(equation.currentAnswerText)
        .frame(width: 130)
        .background(evaluationColor)
        .clipShape(Capsule())
        .padding(.leading, 20)
    }
  }
  
  private var evaluationColor: Color {
    if equation.finishedAnswering {
      return equation.correctlyAnswered ? Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)) : Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
    } else {
      return isCurrentEquation ? Color(#colorLiteral(red: 0.2415105691, green: 0.41326858, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
  }
}
