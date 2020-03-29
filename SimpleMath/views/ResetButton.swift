//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct ResetButton: View {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  let action: () -> Void
  
  var body: some View {
    Button(action: self.action) {
      Image(systemName: Symbol.reset.rawValue)
        .font(Font.system(size: self.hSizeClass.isRegular ? 80 : 40, weight: .bold, design: .monospaced))
        .foregroundColor(Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)))
    }
    .padding(.trailing, 20)
    .padding(.top, 34)
  }
}
