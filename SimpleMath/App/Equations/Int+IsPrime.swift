//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Foundation

extension Int {
  var isPrime: Bool {
    guard self >= 2     else { return false }
    guard self != 2     else { return true  }
    guard self % 2 != 0 else { return false }
    return !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains { self % $0 == 0 }
  }
}
