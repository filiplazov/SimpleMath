//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct InputView: View {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  @EnvironmentObject private var viewModel: SimpleMathViewModel
  let maxWidth: CGFloat

  var body: some View {
    HStack {
      CommandInputButton(
        symbol: .erase,
        color: .discard,
        action: viewModel.erase,
        isEnabled: viewModel.commandsAvailable
      )
        .font(.commandFont(for: maxWidth, horizontalSizeClass: hSizeClass))
        .padding(.horizontal, hSizeClass.isRegular ? 60 : 0)
      NumbersInputView(spacing: hSizeClass == .regular ? 100 : 48, action: viewModel.input(number:))
        .font(.numbersFont(for: maxWidth, horizontalSizeClass: hSizeClass))
      CommandInputButton(
        symbol: .checkmark,
        color: .confirm,
        action: viewModel.evaluate,
        isEnabled: viewModel.commandsAvailable
      )
        .font(.commandFont(for: maxWidth, horizontalSizeClass: hSizeClass))
        .padding(.horizontal, hSizeClass.isRegular ? 60 : 0)
    }
  }
}

private extension Font {
  static func commandFont(for width: CGFloat, horizontalSizeClass: UserInterfaceSizeClass?) -> Font {
    Font.system(size: width * 0.08, weight: .heavy, design: .monospaced)
  }

  static func numbersFont(for width: CGFloat, horizontalSizeClass: UserInterfaceSizeClass?) -> Font {
    let scale: CGFloat = horizontalSizeClass == .regular ? 0.11 : 0.15
    return Font.system(size: width * scale, weight: .heavy, design: .monospaced)
  }
}
