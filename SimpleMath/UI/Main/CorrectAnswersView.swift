//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import CornerStacks
import SwiftUI

struct CorrectAnswersView: View {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  let correctAnswers: Int
  
  var body: some View {
    Group {
      if hSizeClass.isRegular {
        TopTrailingVStack(spacing: 10) {
          InnerContent(correctAnswers: correctAnswers, bigSize: true)
        }
      } else {
        TopTrailingHStack(spacing: 10) {
          InnerContent(correctAnswers: correctAnswers, bigSize: false)
        }
      }
    }
  }
}

private struct InnerContent: View {
  let correctAnswers: Int
  let bigSize: Bool
  
  var body: some View {
    Group {
      Text(correctAnswers.description)
        .font(Font.system(size: bigSize ? 70 : 40, weight: .bold, design: .monospaced))
      Image(withSymbol: .star)
        .font(Font.system(size: bigSize ? 50 : 30, weight: .bold, design: .monospaced))
    }
    .opacity(correctAnswers > 0 ? 1 : 0)
    .foregroundColor(.correctAnswer)
  }
}

private extension Font {
  static func commandFont(for proxy: GeometryProxy, horizontalSizeClass: UserInterfaceSizeClass?) -> Font {
    Font.system(size: proxy.size.width * 0.08, weight: .heavy, design: .monospaced)
  }
  
  static func numbersFont(for proxy: GeometryProxy, horizontalSizeClass: UserInterfaceSizeClass?) -> Font {
    let scale: CGFloat = horizontalSizeClass == .regular ? 0.11 : 0.15
    return Font.system(size: proxy.size.width * scale, weight: .heavy, design: .monospaced)
  }
}
