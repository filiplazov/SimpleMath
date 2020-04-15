//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

struct SettingsBundle: Equatable, Codable {
  var minimumDigit: Int
  var maximumDigit: Int
  var equationsCount: Int
  var equationTypes: Set<EquationType>
  var areSoundsEnabled: Bool
}

extension SettingsBundle {
  static var `default`: SettingsBundle {
    SettingsBundle(
      minimumDigit: 0,
      maximumDigit: 9,
      equationsCount: 10,
      equationTypes: [.addition, .subtraction],
      areSoundsEnabled: true
    )
  }
}
