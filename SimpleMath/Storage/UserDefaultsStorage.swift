//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Foundation

final class UserDefaultsStorage: Storage {
  private var storedDataCache: StoredData?
  let modelVersion: String
  let key: String

  init(withKey: String, modelVersion: String) {
    key = withKey
    self.modelVersion = modelVersion
  }

  func store(settingsBundle: SettingsBundle) {
    var data = loadStoredData()
    data.settingsBundle = settingsBundle
    save(storedData: data)

  }

  func loadSettingsBundle() -> SettingsBundle {
    loadStoredData().settingsBundle
  }

  func store(onboardingBundle: OnboardingBundle) {
    var data = loadStoredData()
    data.onboardingBundle = onboardingBundle
    save(storedData: data)
  }

  func loadOnboardingBundle() -> OnboardingBundle {
    loadStoredData().onboardingBundle
  }

  private func loadStoredData() -> StoredData {
    if let cache = storedDataCache {
      return cache
    } else {
      var storedData: StoredData
      do {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
          storedData = try JSONDecoder().decode(StoredData.self, from: data)
        } else {
          print("No data found for key \(key), generating default values")
          storedData = .useDefault
          storedData.modelVersion = modelVersion
        }
      } catch {
        print("error reading stored data \(error), generating default values")
        storedData = .useDefault
        storedData.modelVersion = modelVersion
      }
      storedDataCache = storedData
      return storedData
    }
  }

  private func save(storedData: StoredData) {
    storedDataCache = storedData
    do {
      try UserDefaults.standard.set(JSONEncoder().encode(storedData), forKey: key)
    } catch {
      print("failed saving data :", error)
    }
  }
}

// the model version is stored if migrations are needed in the future
private struct StoredData: Codable {
  var modelVersion: String
  var settingsBundle: SettingsBundle
  var onboardingBundle: OnboardingBundle
}

extension StoredData {
  static var useDefault: StoredData {
    StoredData(modelVersion: "", settingsBundle: .default, onboardingBundle: .default)
  }
}
