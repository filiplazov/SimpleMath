//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

struct Operator {
  let equationType: EquationType
  let symbol: String
  let function: (Int, Int) -> Int
  
  func callAsFunction(_ left: Int, _ right: Int) -> Int {
   function(left, right)
  }
}

extension Operator: Equatable {
  static func == (lhs: Operator, rhs: Operator) -> Bool {
    lhs.equationType == rhs.equationType && lhs.symbol == rhs.symbol
  }
}

extension Operator {
  static var add: Operator { Operator(equationType: .addition, symbol: "+", function: +) }
  static var subtract: Operator { Operator(equationType: .subtraction, symbol: "-", function: -) }
  static var multiply: Operator { Operator(equationType: .multiplication, symbol: "×", function: *) }
  static var divide: Operator { Operator(equationType: .division, symbol: "÷", function: /) }
}
