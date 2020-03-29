//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct InputView: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @ObservedObject var viewModel: SimpleMathViewModel
  
  var body: some View {
    GeometryReader { proxy in
      HStack {
        Spacer(minLength: self.horizontalSizeClass == .regular ? 50 : 0)
        CommandInputButton(symbol: .erase, color: Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)), action: self.viewModel.erase, isEnabled: self.viewModel.commandsAvailable)
          .font(.commandFont(for: proxy, horizontalSizeClass: self.horizontalSizeClass))
        NumbersInputView(spacing: self.horizontalSizeClass == .regular ? 100 : 48, action: { self.viewModel.input(number: $0) })
          .font(.numbersFont(for: proxy, horizontalSizeClass: self.horizontalSizeClass))
        CommandInputButton(symbol: .evaluate, color: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), action: self.viewModel.evaluate, isEnabled: self.viewModel.commandsAvailable)
          .font(.commandFont(for: proxy, horizontalSizeClass: self.horizontalSizeClass))
        Spacer(minLength: self.horizontalSizeClass == .regular ? 50 : 0)
      }
    }
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
