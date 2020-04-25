//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

@testable import SimpleMath
import XCTest

class StoredSettingsTests: XCTestCase {

  func testInit_loadsInitialBundleFromStorageAndPublishesIt() {
    let storageMock = StorageMock(settingsBundle: .bundleSample1)
    let storedSettings = StoredSettings(withStorage: storageMock)
    let expectedValue: SettingsBundle = .bundleSample1
    var receivedValues: [SettingsBundle] = []
    let subscription = storedSettings.currentSettings.sink(receiveValue: { receivedValues.append($0) })
    subscription.cancel()
    XCTAssertEqual(receivedValues.count, 1, "Expected only a single value published by the `currentSettings` publisher")
    XCTAssertEqual(expectedValue, receivedValues.first, "`bundleSample1` value loaded from storage should be published")
  }

  func testUpdateSettings_ifNewSettingsAreDefferentFromCurrent_storesTheBundleAndPublishesTheNewlyUpdatedBundle() {
    let storageMock = StorageMock(settingsBundle: .bundleSample1)
    let storedSettings = StoredSettings(withStorage: storageMock)
    let expectedValues: [SettingsBundle] = [.bundleSample1, .bundleSample2]
    var receivedValues: [SettingsBundle] = []
    let subscription = storedSettings.currentSettings.sink(receiveValue: { receivedValues.append($0) })
    storedSettings.updateSettings(bundle: .bundleSample2)
    subscription.cancel()
    XCTAssertEqual(receivedValues.count, 2, "Expected 2 values published by the `currentSettings` publisher")
    XCTAssertEqual(expectedValues, receivedValues, "Expected published values `.bundleSample1` and `.bundleSample2`")
    XCTAssertEqual(storageMock.settingsBundle, .bundleSample2, "The new bundle `.bundleSample2` should be stored in storage")
  }

  func testUpdateSettings_ifNewSettingsAreSameAsCurrent_DoesNotStoreTheBundleAndDoesNotPublishesTheNewlyUpdatedBundle() {
    let storageMock = StorageMock(settingsBundle: .bundleSample1)
    let storedSettings = StoredSettings(withStorage: storageMock)
    let expectedValues: [SettingsBundle] = [.bundleSample1]
    var receivedValues: [SettingsBundle] = []
    let subscription = storedSettings.currentSettings.sink(receiveValue: { receivedValues.append($0) })
    storedSettings.updateSettings(bundle: .bundleSample1)
    subscription.cancel()
    XCTAssertEqual(receivedValues.count, 1, "Expected only a single value published by the `currentSettings` publisher")
    XCTAssertEqual(expectedValues, receivedValues, "Expected published value is only `.bundleSample1`")
    XCTAssertEqual(storageMock.settingsBundle, .bundleSample1, "The storage should still have the same `.bundleSample1`")
  }

}

private extension SettingsBundle {
  static let bundleSample1 = SettingsBundle(
    minimumDigit: 1,
    maximumDigit: 20,
    equationsCount: 20,
    equationTypes: [.addition, .multiplication],
    areSoundsEnabled: false
  )

  static let bundleSample2 = SettingsBundle(
    minimumDigit: 1,
    maximumDigit: 30,
    equationsCount: 5,
    equationTypes: [.subtraction, .division],
    areSoundsEnabled: true
  )
}
