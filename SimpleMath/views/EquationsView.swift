//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct EquationsView: View {
  @State private var equationSize: CGSize = .zero
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @ObservedObject var viewModel: SimpleMathViewModel
  let maxWidth: CGFloat
  
  var body: some View {
    ZStack {
      GeometryReader { proxy in
        EquationRowView(equation: self.viewModel.equations[0], isCurrentEquation: self.viewModel.currentEquationIndex == 0, answerSlotWidth: self.answerSlotWidth)
          .offset(x: 0, y: self.verticalOffset(forIndex: 0))
          .opacity(self.opacity(forIndex: 0))
          .onAppear {
            self.equationSize = proxy.size
        }
      }
      ForEach(1..<viewModel.equations.count, id: \.self) { index in
        EquationRowView(equation: self.viewModel.equations[index], isCurrentEquation: self.viewModel.currentEquationIndex == index, answerSlotWidth: self.answerSlotWidth)
          .offset(x: 0, y: self.verticalOffset(forIndex: index))
          .opacity(self.opacity(forIndex: index))
      }
    }
    .frame(height: equationSize.height * 5 + spacing * 3, alignment: .bottom)
    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
    .font(.equationFont(for: self.maxWidth, horizontalSizeClass: self.horizontalSizeClass))
  }
  
  private func verticalOffset(forIndex index: Int) -> CGFloat {
    if index == viewModel.currentEquationIndex {
      return 0
    } else {
      return CGFloat(CGFloat((index - viewModel.currentEquationIndex)) * (equationSize.height + spacing))
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
  
  private var spacing: CGFloat {
    horizontalSizeClass == .regular ? 20 : 12
  }
  
  private var padding: CGFloat {
    horizontalSizeClass == .regular ? 130 : 40
  }
  
  private var answerSlotWidth: CGFloat {
    horizontalSizeClass == .regular ? 130 : 80
  }
}

private extension Font {
  static func equationFont(for maxWidth: CGFloat, horizontalSizeClass: UserInterfaceSizeClass?) -> Font {
    let scale: CGFloat = horizontalSizeClass == .regular ? 0.085 : 0.10
    return Font.system(size: maxWidth * scale, weight: .bold, design: .monospaced)
  }
}


private struct EquationRowView: View {
  let equation: Equation
  let isCurrentEquation: Bool
  let answerSlotWidth: CGFloat
  
  var body: some View {
    HStack {
      Text(equation.question)
      Text(equation.currentAnswerText)
        .frame(width: answerSlotWidth)
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
