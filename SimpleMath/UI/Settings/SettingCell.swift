//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct SettingCell: ViewModifier {
  var maxWidth: CGFloat
  
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: maxWidth)
      .background(Color.settingCellBackgroundBase.opacity(0.05))
      .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
  }
}
