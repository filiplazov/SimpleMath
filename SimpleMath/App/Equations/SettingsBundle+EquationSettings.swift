//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

extension SettingsBundle {
  var equationSettings: EquationSettings {
    EquationSettings(
      minimumDigit: minimumDigit,
      maximumDigit: maximumDigit,
      equationsCount: equationsCount,
      equationTypes: equationTypes
    )
  }
}
