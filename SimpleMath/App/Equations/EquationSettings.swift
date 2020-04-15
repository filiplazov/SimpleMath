//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

struct EquationSettings: Equatable {
  var minimumDigit: Int
  var maximumDigit: Int
  var equationsCount: Int
  var equationTypes: Set<EquationType>
}
