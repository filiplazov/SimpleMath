//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct ResetButton: View {
  let action: () -> Void
  
  var body: some View {
    Button(action: self.action) {
      Image(systemName: Symbol.reset.rawValue)
        .padding([.trailing, .top], 40)
        .font(Font.system(size: 80, weight: .bold, design: .monospaced))
        .foregroundColor(Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)))
    }
  }
}
