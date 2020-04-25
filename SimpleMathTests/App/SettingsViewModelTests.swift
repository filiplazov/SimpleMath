//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine
@testable import SimpleMath
import XCTest

class SettingsViewModelTests: XCTestCase {

  func testInit_initializesPropertiesFromSettingsCorrectly() {
    let bundle = SettingsBundle(
      minimumDigit: 10,
      maximumDigit: 20,
      equationsCount: 15,
      equationTypes: [.subtraction, .multiplication],
      areSoundsEnabled: false
    )
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(bundle)
    let viewModel = SettingsViewModel(settings: settingsMock)

    XCTAssertEqual(viewModel.minRangeText, "10", "expected minimum range text to be 10")
    XCTAssertEqual(viewModel.maxRangeText, "20", "expected maximum range text to be 10")
    XCTAssertTrue(viewModel.isRangeValid, "10 is less than 20 so range should be valid")
    XCTAssertEqual(viewModel.numberOfEquations, 15, "expected numberOfEquations to be 15")
    XCTAssertFalse(viewModel.additionEnabled, "expected additionEnabled to be false")
    XCTAssertTrue(viewModel.subtractonEnabled, "expected subtractonEnabled to be true")
    XCTAssertTrue(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be true")
    XCTAssertFalse(viewModel.divisionEnabled, "expected divisionEnabled to be false")
    XCTAssertFalse(viewModel.areSoundsEnabled, "expected areSoundsEnabled to be false")
  }

  func testUpdateMinRangeText_updatesTheMinRange_recalculatesIsRangeValid() {
    let bundle = SettingsBundle.default
      .set(\.minimumDigit, to: 1)
      .set(\.maximumDigit, to: 5)
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(bundle)
    let viewModel = SettingsViewModel(settings: settingsMock)
    XCTAssertEqual(viewModel.minRangeText, "1", "expected minimum range text to be 1")
    XCTAssertEqual(viewModel.maxRangeText, "5", "expected maximum range text to be 5")
    XCTAssertTrue(viewModel.isRangeValid, "1 is less than 5 so range should be valid")

    viewModel.updateMinRange(text: "3")

    XCTAssertEqual(viewModel.minRangeText, "3", "expected minimum range text to be 3")
    XCTAssertEqual(viewModel.maxRangeText, "5", "expected maximum range text to be 5")
    XCTAssertTrue(viewModel.isRangeValid, "3 is less than 5 so range should be valid")

    viewModel.updateMinRange(text: "10")

    XCTAssertEqual(viewModel.minRangeText, "10", "expected minimum range text to be 10")
    XCTAssertEqual(viewModel.maxRangeText, "5", "expected maximum range text to be 5")
    XCTAssertFalse(viewModel.isRangeValid, "10 is greater than 5 so range should be invalid")

    viewModel.updateMinRange(text: "5")

    XCTAssertEqual(viewModel.minRangeText, "5", "expected minimum range text to be 5")
    XCTAssertEqual(viewModel.maxRangeText, "5", "expected maximum range text to be 5")
    XCTAssertFalse(viewModel.isRangeValid, "5 is equal to 5 so range should be invalid")

    viewModel.updateMinRange(text: "")

    XCTAssertEqual(viewModel.minRangeText, "", "expected minimum range text is empty")
    XCTAssertEqual(viewModel.maxRangeText, "5", "expected maximum range text to be 10")
    XCTAssertFalse(viewModel.isRangeValid, "empty minimum range text makes range invalid")

    viewModel.updateMinRange(text: "0")

    XCTAssertEqual(viewModel.minRangeText, "0", "expected minimum range text to be 0")
    XCTAssertEqual(viewModel.maxRangeText, "5", "expected maximum range text to be 10")
    XCTAssertTrue(viewModel.isRangeValid, "0 is less than 5 so range should be valid")
  }

  func testUpdateMaxRangeText_updatesTheMinRange_recalculatesIsRangeValid() {
    let bundle = SettingsBundle.default
      .set(\.minimumDigit, to: 10)
      .set(\.maximumDigit, to: 20)
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(bundle)
    let viewModel = SettingsViewModel(settings: settingsMock)
    XCTAssertEqual(viewModel.minRangeText, "10", "expected minimum range text to be 10")
    XCTAssertEqual(viewModel.maxRangeText, "20", "expected maximum range text to be 20")
    XCTAssertTrue(viewModel.isRangeValid, "5 is greater than 1 so range should be valid")

    viewModel.updateMaxRange(text: "25")

    XCTAssertEqual(viewModel.minRangeText, "10", "expected minimum range text to be 10")
    XCTAssertEqual(viewModel.maxRangeText, "25", "expected maximum range text to be 25")
    XCTAssertTrue(viewModel.isRangeValid, "25 is greater than 10 so range should be valid")

    viewModel.updateMaxRange(text: "5")

    XCTAssertEqual(viewModel.minRangeText, "10", "expected minimum range text to be 10")
    XCTAssertEqual(viewModel.maxRangeText, "5", "expected maximum range text to be 5")
    XCTAssertFalse(viewModel.isRangeValid, "5 is less 10 so range should be invalid")

    viewModel.updateMaxRange(text: "10")

    XCTAssertEqual(viewModel.minRangeText, "10", "expected minimum range text to be 10")
    XCTAssertEqual(viewModel.maxRangeText, "10", "expected maximum range text to be 10")
    XCTAssertFalse(viewModel.isRangeValid, "10 is equal to 10 so range should be invalid")

    viewModel.updateMaxRange(text: "")

    XCTAssertEqual(viewModel.minRangeText, "10", "expected minimum range text to be 10")
    XCTAssertEqual(viewModel.maxRangeText, "", "expected maximum range text is empty")
    XCTAssertFalse(viewModel.isRangeValid, "empty maximum range text makes range invalid")

    viewModel.updateMaxRange(text: "99")

    XCTAssertEqual(viewModel.minRangeText, "10", "expected minimum range text to be 10")
    XCTAssertEqual(viewModel.maxRangeText, "99", "expected maximum range text to be 99")
    XCTAssertTrue(viewModel.isRangeValid, "99 is greater than 10 so range should be valid")

    viewModel.updateMaxRange(text: "100")

    XCTAssertEqual(viewModel.minRangeText, "10", "expected minimum range text to be 10")
    XCTAssertEqual(viewModel.maxRangeText, "99", "expected maximum range text to be 99, numbers above 100 are ignored")
    XCTAssertTrue(viewModel.isRangeValid, "99 is greater than 10 so range should be valid")
  }

  func testDecreaseNumberOfEquations_decreasesTheNumberOfEquationsNoLessThan5() {
    let bundle = SettingsBundle.default
      .set(\.equationsCount, to: 7)
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(bundle)
    let viewModel = SettingsViewModel(settings: settingsMock)
    XCTAssertEqual(viewModel.numberOfEquations, 7, "expected numberOfEquations to be 7")

    viewModel.decreaseNumberOfEquations()
    XCTAssertEqual(viewModel.numberOfEquations, 6, "expected numberOfEquations to be 6")
    viewModel.decreaseNumberOfEquations()
    XCTAssertEqual(viewModel.numberOfEquations, 5, "expected numberOfEquations to be 5")
    viewModel.decreaseNumberOfEquations()
    XCTAssertEqual(viewModel.numberOfEquations, 5, "expected numberOfEquations to still be 5, it is the lower limit")
  }

  func testIncreaseNumberOfEquations_increasesTheNumberOfEquationsNoMoreThan30() {
    let bundle = SettingsBundle.default
      .set(\.equationsCount, to: 28)
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(bundle)
    let viewModel = SettingsViewModel(settings: settingsMock)
    XCTAssertEqual(viewModel.numberOfEquations, 28, "expected numberOfEquations to be 28")

    viewModel.increaseNumberOfEquations()
    XCTAssertEqual(viewModel.numberOfEquations, 29, "expected numberOfEquations to be 29")
    viewModel.increaseNumberOfEquations()
    XCTAssertEqual(viewModel.numberOfEquations, 30, "expected numberOfEquations to be 30")
    viewModel.increaseNumberOfEquations()
    XCTAssertEqual(viewModel.numberOfEquations, 30, "expected numberOfEquations to still be 30, it is the upper limit")
  }

  func testEnableEquationType_enablesSpecificEquationType() {
    let bundle = SettingsBundle.default
      .set(\.equationTypes, to: [.division])
    let settingsMock = SettingsMock()
    let settingsPublisher = CurrentValueSubject<SettingsBundle, Never>(bundle)
    settingsMock.currentSettings = settingsPublisher.eraseToAnyPublisher()
    let viewModel = SettingsViewModel(settings: settingsMock)

    XCTAssertFalse(viewModel.additionEnabled, "expected additionEnabled to be false")
    XCTAssertFalse(viewModel.subtractonEnabled, "expected subtractonEnabled to be false")
    XCTAssertFalse(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be false")
    XCTAssertTrue(viewModel.divisionEnabled, "expected divisionEnabled to be true")

    viewModel.enableEquation(type: .addition)

    XCTAssertTrue(viewModel.additionEnabled, "expected additionEnabled to be true")
    XCTAssertFalse(viewModel.subtractonEnabled, "expected subtractonEnabled to be false")
    XCTAssertFalse(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be false")
    XCTAssertTrue(viewModel.divisionEnabled, "expected divisionEnabled to be true")

    viewModel.enableEquation(type: .subtraction)

    XCTAssertTrue(viewModel.additionEnabled, "expected additionEnabled to be true")
    XCTAssertTrue(viewModel.subtractonEnabled, "expected subtractonEnabled to be true")
    XCTAssertFalse(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be false")
    XCTAssertTrue(viewModel.divisionEnabled, "expected divisionEnabled to be true")

    viewModel.enableEquation(type: .multiplication)

    XCTAssertTrue(viewModel.additionEnabled, "expected additionEnabled to be true")
    XCTAssertTrue(viewModel.subtractonEnabled, "expected subtractonEnabled to be true")
    XCTAssertTrue(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be true")
    XCTAssertTrue(viewModel.divisionEnabled, "expected divisionEnabled to be true")

    settingsPublisher.value = bundle.set(\.equationTypes, to: [.addition, .subtraction, .multiplication])

    XCTAssertTrue(viewModel.additionEnabled, "expected additionEnabled to be true")
    XCTAssertTrue(viewModel.subtractonEnabled, "expected subtractonEnabled to be true")
    XCTAssertTrue(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be true")
    XCTAssertFalse(viewModel.divisionEnabled, "expected divisionEnabled to be false")

    viewModel.enableEquation(type: .division)

    XCTAssertTrue(viewModel.additionEnabled, "expected additionEnabled to be true")
    XCTAssertTrue(viewModel.subtractonEnabled, "expected subtractonEnabled to be true")
    XCTAssertTrue(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be true")
    XCTAssertTrue(viewModel.divisionEnabled, "expected divisionEnabled to be true")
  }

  func testDisableEquationType_disablesSpecificEquationType() {
    let bundle = SettingsBundle.default
      .set(\.equationTypes, to: [.addition, .subtraction, .multiplication, .division])
    let settingsMock = SettingsMock()
    let settingsPublisher = CurrentValueSubject<SettingsBundle, Never>(bundle)
    settingsMock.currentSettings = settingsPublisher.eraseToAnyPublisher()
    let viewModel = SettingsViewModel(settings: settingsMock)

    XCTAssertTrue(viewModel.additionEnabled, "expected additionEnabled to be true")
    XCTAssertTrue(viewModel.subtractonEnabled, "expected subtractonEnabled to be true")
    XCTAssertTrue(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be true")
    XCTAssertTrue(viewModel.divisionEnabled, "expected divisionEnabled to be true")

    viewModel.disableEquation(type: .addition)

    XCTAssertFalse(viewModel.additionEnabled, "expected additionEnabled to be false")
    XCTAssertTrue(viewModel.subtractonEnabled, "expected subtractonEnabled to be true")
    XCTAssertTrue(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be true")
    XCTAssertTrue(viewModel.divisionEnabled, "expected divisionEnabled to be true")

    viewModel.disableEquation(type: .subtraction)

    XCTAssertFalse(viewModel.additionEnabled, "expected additionEnabled to be false")
    XCTAssertFalse(viewModel.subtractonEnabled, "expected subtractonEnabled to be false")
    XCTAssertTrue(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be true")
    XCTAssertTrue(viewModel.divisionEnabled, "expected divisionEnabled to be true")

    viewModel.disableEquation(type: .multiplication)

    XCTAssertFalse(viewModel.additionEnabled, "expected additionEnabled to be false")
    XCTAssertFalse(viewModel.subtractonEnabled, "expected subtractonEnabled to be false")
    XCTAssertFalse(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be false")
    XCTAssertTrue(viewModel.divisionEnabled, "expected divisionEnabled to be true")

    viewModel.disableEquation(type: .division)

    XCTAssertFalse(viewModel.additionEnabled, "expected additionEnabled to be false")
    XCTAssertFalse(viewModel.subtractonEnabled, "expected subtractonEnabled to be false")
    XCTAssertFalse(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be false")
    XCTAssertTrue(
      viewModel.divisionEnabled,
      "division will still be enabled because it is not allowed to disable the last equation type, there must be at least 1"
    )

    // enabling addition so that disabling .division is now possible, it is no longer the only equation type enabled
    viewModel.enableEquation(type: .addition)
    viewModel.disableEquation(type: .division)

    XCTAssertTrue(viewModel.additionEnabled, "expected additionEnabled to be true")
    XCTAssertFalse(viewModel.subtractonEnabled, "expected subtractonEnabled to be false")
    XCTAssertFalse(viewModel.multiplicationEnabled, "expected multiplicationEnabled to be false")
    XCTAssertFalse(viewModel.divisionEnabled, "expected divisionEnabled to be false")
  }

  func testUpdateSoundsEnabled_togglesSoundsOnAndOff() {
    let bundle = SettingsBundle.default.set(\.areSoundsEnabled, to: false)
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(bundle)
    let viewModel = SettingsViewModel(settings: settingsMock)
    XCTAssertFalse(viewModel.areSoundsEnabled, "initially the sounds are disabled")

    viewModel.updateSoundsEnabled(to: true)
    XCTAssertTrue(viewModel.areSoundsEnabled, "sounds should be enabled now")

    viewModel.updateSoundsEnabled(to: false)
    XCTAssertFalse(viewModel.areSoundsEnabled, "sounds should be dsiabled again")
  }

  func testCommitChanges_updatesSettingWithNewBundleCreatedFromCurrentProperties() {
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(.default)
    let viewModel = SettingsViewModel(settings: settingsMock)
    XCTAssertNil(settingsMock.updatedBundle, "before doing anything check if `updatedBundle` is nil for the mock")

    viewModel.disableEquation(type: .subtraction)
    viewModel.enableEquation(type: .multiplication)
    viewModel.increaseNumberOfEquations()
    viewModel.updateMinRange(text: "10")
    viewModel.updateMaxRange(text: "50")
    viewModel.updateSoundsEnabled(to: false)

    let expectedBundle = SettingsBundle(
      minimumDigit: 10,
      maximumDigit: 50,
      equationsCount: 11,
      equationTypes: [.addition, .multiplication],
      areSoundsEnabled: false
    )
    viewModel.commitChanges()
    XCTAssertEqual(
      settingsMock.updatedBundle, expectedBundle,
      "settings should be updated with a new bundle created from the view model parameters"
    )
  }
}
