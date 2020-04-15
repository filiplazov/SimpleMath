//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

@testable import SimpleMath
import XCTest

class SettingsBundleAndEquationSettingsTests: XCTestCase {

  func testEquationSettings_extractsOnlyEquationSettingsProperties() {
    let bundle = SettingsBundle(
      minimumDigit: 1,
      maximumDigit: 30,
      equationsCount: 16,
      equationTypes: [.division, .addition],
      areSoundsEnabled: true
    )
    let expectedEquationSettings = EquationSettings(
      minimumDigit: 1,
      maximumDigit: 30,
      equationsCount: 16,
      equationTypes: [.addition, .division]
    )
    XCTAssertEqual(
      bundle.equationSettings,
      expectedEquationSettings,
      "calling `equationSettings` on bundle should produce expected equationSettings"
    )
  }

}
