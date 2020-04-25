//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Foundation
@testable import SimpleMath
import XCTest

class UserDefaultsStorageTests: XCTestCase {

  override func tearDownWithError() throws {
    UserDefaults.standard.removeObject(forKey: .testKey)
  }

  func testStoreSettingsBundle_encodesBundleAndModelVersionToJsonAndStoresItForTheProvidedKey() throws {
    let defaults = UserDefaults.standard
    let storage = UserDefaultsStorage(withKey: .testKey, modelVersion: .testVersion)
    XCTAssertNil(defaults.object(forKey: .testKey), "A check if key value is empty before proceeding")
    storage.store(settingsBundle: .sample)
    let jsonData = try XCTUnwrap(defaults.object(forKey: .testKey) as? Data)
    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]
    XCTAssertEqual(jsonObject?["modelVersion"] as? String, String.testVersion, "saved data should contain correct model version")

    let settingsBundleObject = try XCTUnwrap(jsonObject?["settingsBundle"])
    let settingsBundleJsonData = try JSONSerialization.data(withJSONObject: settingsBundleObject, options: [])
    let decodedSettingsBundle = try JSONDecoder().decode(SettingsBundle.self, from: settingsBundleJsonData)
    XCTAssertEqual(decodedSettingsBundle, .sample, "the settings bundle should be stored with correct values in JSON format")
  }

  func testStoreOnboardingBundle_encodesBundleAndModelVersionToJsonAndStoresItForTheProvidedKey() throws {
    let defaults = UserDefaults.standard
    let storage = UserDefaultsStorage(withKey: .testKey, modelVersion: .testVersion)
    XCTAssertNil(defaults.object(forKey: .testKey), "A check if key value is empty before proceeding")
    storage.store(onboardingBundle: .sample)
    let jsonData = try XCTUnwrap(defaults.object(forKey: .testKey) as? Data)
    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]
    XCTAssertEqual(jsonObject?["modelVersion"] as? String, String.testVersion, "saved data should contain correct model version")

    let onboardingBundleObject = try XCTUnwrap(jsonObject?["onboardingBundle"])
    let onboardingBundleJsonData = try JSONSerialization.data(withJSONObject: onboardingBundleObject, options: [])
    let decodedOnboardingBundle = try JSONDecoder().decode(OnboardingBundle.self, from: onboardingBundleJsonData)
    XCTAssertEqual(decodedOnboardingBundle, .sample, "the onboarding bundle should be stored with correct values in JSON format")
  }

  func testLoadSettingsBundle_decodesAndReturnsBundle() {
    let defaults = UserDefaults.standard
    let storage = UserDefaultsStorage(withKey: .testKey, modelVersion: .testVersion)
    XCTAssertNil(defaults.object(forKey: .testKey), "A check if key value is empty before proceeding")
    let jsonData = String.sampleJson.data(using: .utf8)
    defaults.set(jsonData, forKey: .testKey)
    XCTAssertEqual(storage.loadSettingsBundle(), .sample, "loadSettingsBundle should correctly decode and return the `sample`")
  }

  func testLoadSettingsBundle_whenNothingWasSavedBefore_loadsDefaultSettingsBundle() {
    let defaults = UserDefaults.standard
    let storage = UserDefaultsStorage(withKey: .testKey, modelVersion: .testVersion)
    XCTAssertNil(defaults.object(forKey: .testKey), "A check if key value is empty before proceeding")
    XCTAssertEqual(
      storage.loadSettingsBundle(),
      .default,
      "loadSettingsBundle should return `default` if nothing is found for `testKey`"
    )
  }

  func testLoadSettingsBundle_whenStoredDataIsCorrupted_loadsDefaultSettingsBundle() {
    let defaults = UserDefaults.standard
    let storage = UserDefaultsStorage(withKey: .testKey, modelVersion: .testVersion)
    XCTAssertNil(defaults.object(forKey: .testKey), "A check if key value is empty before proceeding")
    let jsonData = String.invalidJson.data(using: .utf8)
    defaults.set(jsonData, forKey: .testKey)
    XCTAssertEqual(
      storage.loadSettingsBundle(),
      .default,
      "loadSettingsBundle should return `default` if the underlying json is corrupted / invalid"
    )
  }

  func testOnboardingBundle_decodesAndReturnsBundle() {
    let defaults = UserDefaults.standard
    let storage = UserDefaultsStorage(withKey: .testKey, modelVersion: .testVersion)
    XCTAssertNil(defaults.object(forKey: .testKey), "A check if key value is empty before proceeding")
    let jsonData = String.sampleJson.data(using: .utf8)
    defaults.set(jsonData, forKey: .testKey)
    XCTAssertEqual(storage.loadOnboardingBundle(), .sample, "loadSettingsBundle should correctly decode and return the `sample`")
  }

  func testLoadOnboardingBundle_whenNothingWasSavedBefore_loadsDefaultSettingsBundle() {
    let defaults = UserDefaults.standard
    let storage = UserDefaultsStorage(withKey: .testKey, modelVersion: .testVersion)
    XCTAssertNil(defaults.object(forKey: .testKey), "A check if key value is empty before proceeding")
    XCTAssertEqual(
      storage.loadOnboardingBundle(),
      .default,
      "loadOnboardingBundle should return `default` if nothing is found for `testKey`"
    )
  }

  func testLoadOnboardingBundle_whenStoredDataIsCorrupted_loadsDefaultSettingsBundle() {
    let defaults = UserDefaults.standard
    let storage = UserDefaultsStorage(withKey: .testKey, modelVersion: .testVersion)
    XCTAssertNil(defaults.object(forKey: .testKey), "A check if key value is empty before proceeding")
    let jsonData = String.invalidJson.data(using: .utf8)
    defaults.set(jsonData, forKey: .testKey)
    XCTAssertEqual(
      storage.loadOnboardingBundle(),
      .default,
      "loadOnboardingBundle should return `default` if the underlying json is corrupted / invalid"
    )
  }

}

private extension String {
  static let testKey = "test.key"
  static let testVersion = "9.9.9"

  static let sampleJson =
  """
  {
    "modelVersion":"9.9.9",
    "settingsBundle": {
      "equationTypes": [
        "multiplication",
        "addition"],
      "equationsCount": 20,
      "areSoundsEnabled": false,
      "minimumDigit": 1,
      "maximumDigit": 20
    },
    "onboardingBundle": {
      "seenSettingsHint": true
    }
  }
  """
  static let invalidJson = "{{{{}"
}

private extension SettingsBundle {
  static let sample = SettingsBundle(
    minimumDigit: 1,
    maximumDigit: 20,
    equationsCount: 20,
    equationTypes: [.addition, .multiplication],
    areSoundsEnabled: false
  )
}

private extension OnboardingBundle {
  static let sample = OnboardingBundle(seenSettingsHint: true)
}
