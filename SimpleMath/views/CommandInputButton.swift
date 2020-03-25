//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct CommandInputButton: View {
  let symbol: Symbol
  let color: Color
  let action: () -> Void
  let isEnabled: Bool
  
  var body: some View {
    Button(action: { withAnimation { self.action() } }, label: { Image(systemName: symbol.rawValue) })
      .font(Font.system(size: 60, weight: .heavy, design: .monospaced))
      .foregroundColor(color.opacity(isEnabled ? 1.0 : 0.2))
      .disabled(!isEnabled)
      .padding([.leading, .trailing], 30)
  }
}
