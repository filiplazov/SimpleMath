//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct InputView: View {
  @ObservedObject var viewModel: SimpleMathViewModel
  
  var body: some View {
    HStack {
      CommandInputButton(symbol: .erase, color: Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)), action: self.viewModel.erase, isEnabled: self.viewModel.commandsAvailable)
      NumbersInputView(action: { self.viewModel.input(number: $0) })
      CommandInputButton(symbol: .evaluate, color: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), action: self.viewModel.evaluate, isEnabled: self.viewModel.commandsAvailable)
    }
  }
}
