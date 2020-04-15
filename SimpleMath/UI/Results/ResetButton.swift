//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct ResetButton: View {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Image(withSymbol: .reset)
        .font(Font.system(size: hSizeClass.isRegular ? 80 : 40, weight: .bold, design: .monospaced))
        .foregroundColor(.confirm)
    }
    .padding(.trailing, 20)
    .padding(.top, 34)
  }
}
