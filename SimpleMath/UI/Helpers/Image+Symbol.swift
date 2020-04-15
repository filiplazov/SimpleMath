//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

extension Image {
  init(withSymbol symbol: Symbol) {
    self.init(systemName: symbol.rawValue)
  }
}
