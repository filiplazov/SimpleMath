//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct EquationsView: View {
  @State private var equationSize: CGSize = CGSize(width: 20,height: 20)
  @Environment(\.horizontalSizeClass) private var hSizeClass
  @EnvironmentObject private var viewModel: SimpleMathViewModel
  let maxWidth: CGFloat
  
  var body: some View {
    ZStack() {
      // fake invisible maximum character equation for measuring: operand + operand = answer
      HStack {
        Text(verbatim: .emptySpace(6) + .emptySpace(self.viewModel.operandDigitCount * 2))
        Text(verbatim: .emptySpace(self.viewModel.answerDigitCount))
          .frame(width: self.answerSlotWidth)
          .clipShape(Capsule())
      }
      .font(.equationFont(
        for: maxWidth,
        horizontalSizeClass: hSizeClass,
        operandLength: viewModel.operandDigitCount,
        answerLength: viewModel.answerDigitCount)
      )
        .background(GeometryReader { Color.clear.preference(key: SizeKey.self, value: $0.size) })
        .onPreferenceChange(SizeKey.self) { self.equationSize = $0 }
      
      ForEach(0..<viewModel.equations.count, id: \.self) { index in
        EquationRowView(
          equation: self.viewModel.equations[index],
          isCurrentEquation: self.viewModel.currentEquationIndex == index,
          answerSlotWidth: self.answerSlotWidth,
          opacity: self.opacity(forIndex: index)
        )
          .frame(width: self.equationSize.width, height: self.equationSize.height, alignment: .trailing)
          .offset(x: 0, y: self.verticalOffset(forIndex: index))
      }
      
    }
    .frame(height: equationSize.height * 5 + spacing * 3)
    .font(.equationFont(
      for: self.maxWidth,
      horizontalSizeClass: self.hSizeClass,
      operandLength: self.viewModel.operandDigitCount,
      answerLength: self.viewModel.answerDigitCount)
    )
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
    hSizeClass == .regular ? 20 : 12
  }
  
  private var padding: CGFloat {
    hSizeClass == .regular ? 130 : 40
  }
  
  private var answerSlotWidth: CGFloat {
    switch viewModel.answerDigitCount {
    case 2: return hSizeClass.isRegular ? 130 : 86
    case 3: return hSizeClass.isRegular ? 156 : 90
    case 4: return hSizeClass.isRegular ? 180 : 100
    default: return hSizeClass.isRegular ? 130 : 100
    }
  }
}

private extension Font {
  static func equationFont(for maxWidth: CGFloat, horizontalSizeClass: UserInterfaceSizeClass?, operandLength: Int, answerLength: Int) -> Font {
    let scale: CGFloat
    if horizontalSizeClass == .regular {
      if operandLength == 2 && answerLength == 4 {
        scale = 0.075
      } else {
        scale = 0.085
      }
      
    } else {
      if operandLength == 1 && (answerLength == 2 || answerLength == 1) {
        scale = 0.10
      } else if operandLength == 2 && answerLength == 2 {
        scale = 0.095
      } else if operandLength == 2 && answerLength == 3 {
        scale = 0.09
      } else {
        scale = 0.085
      }
    }
    return Font.system(size: maxWidth * scale, weight: .bold, design: .monospaced)
  }
}


private struct EquationRowView: View {
  let equation: Equation
  let isCurrentEquation: Bool
  let answerSlotWidth: CGFloat
  let opacity: Double
  
  var body: some View {
    HStack(spacing: 0) {
      Text(equation.question)
      Text(equation.currentAnswerText.isEmpty ? " " : equation.currentAnswerText)
        .animation(nil)
        .frame(width: answerSlotWidth)
        .background(evaluationColor.opacity(opacity))
        .clipShape(Capsule())
    }
    .foregroundColor(Color.primaryText.opacity(opacity))
  }
  
  private var evaluationColor: Color {
    if equation.finishedAnswering {
      return equation.correctlyAnswered ? .correctAnswer : .incorrectAnswer
    } else {
      return isCurrentEquation ? .currentAnswer : .unanswered
    }
  }
}

extension StringProtocol {
  static func emptySpace(_ times: Int) -> String {
    String(repeating: " ", count: times)
  }
}
