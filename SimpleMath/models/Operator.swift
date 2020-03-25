//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

struct Operator {
  let function: (Int, Int) -> Int
  let symbol: String
}

extension Operator {
  static var add: Operator { Operator(function: { $0 + $1 }, symbol: "+")}
  static var subtract: Operator { Operator(function: { $0 - $1 }, symbol: "-")}
}
