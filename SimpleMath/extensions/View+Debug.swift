//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

#if DEBUG
extension View {
  func blackBorder() -> some View {
    self.border(Color.black)
  }
  func redBorder() -> some View {
    self.border(Color.red)
  }
  func greenBorder() -> some View {
    self.border(Color.green)
  }
}
#endif
