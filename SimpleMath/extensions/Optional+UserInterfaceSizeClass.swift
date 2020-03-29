//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

extension Optional where Wrapped == UserInterfaceSizeClass {
  var isRegular: Bool {
    self == .regular
  }
  
  var isCompact: Bool {
    self == .compact
  }
}
