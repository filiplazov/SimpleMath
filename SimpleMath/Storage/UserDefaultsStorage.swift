//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Foundation

final class UserDefaultsStorage: Storage {
  
  let modelVersion: String
  let key: String

  init(withKey: String, modelVersion: String) {
    key = withKey
    self.modelVersion = modelVersion
  }

  // Saving Settings bundle store, from cache.
  func store(settingsBundle: SettingsBundle) {
    var data = storedMigrationData
    data.settingsBundle = settingsBundle
    save(storedData: data)
  }

  // Loading of the settings bundle
  func loadSettingsBundle() -> SettingsBundle {
    storedMigrationData.settingsBundle
  }

  // Save onboarding bundle
  func store(onboardingBundle: OnboardingBundle) {
    var data = storedMigrationData
    data.onboardingBundle = onboardingBundle
    save(storedData: data)
  }

  // Loading onboarding bundle
  func loadOnboardingBundle() -> OnboardingBundle {
    storedMigrationData.onboardingBundle
  }
  
  private var storedDataCache: MigrationData?
}

// the model version is stored if migrations are needed in the future
#warning("Can we inline this into UserDefaultsStorage or get rid of it entirely?")
private struct MigrationData: Codable {
  var modelVersion: String
  var settingsBundle: SettingsBundle
  var onboardingBundle: OnboardingBundle
}

extension UserDefaultsStorage {
  
  /// Previously stored migration data.
  ///
  /// - From the cache, if available. The cache has the same lifetime as the session.
  /// - If the cache is not available, try from UserDefaults, save to the cache.
  /// - If UserDefaults doesn't have any data, then return `defaultStoreData` and save to UserDefaults.
  ///
  /// - Returns: a struct describing model version, settings bundle and onboarding bundle.
  private var storedMigrationData: MigrationData {
    
    // Do we have a cache?
    guard let cache = storedDataCache else {
      
      let defaultMigrationData = MigrationData(modelVersion: modelVersion,
                                               settingsBundle: .default,
                                               onboardingBundle: .default)
      
      // We do not. Do we have the previous data in UserDefaults?
      guard let savedJSONData = UserDefaults.standard.value(forKey: key) as? Data else {
        // We don't have previous data.
        print("No data found for key \(key), generating default values")
        storedDataCache = defaultMigrationData
        save(storedData: storedDataCache!)
        return storedDataCache!
      }
      
      // We do have the previous data in UserDefaults.
      // Transform it into a JSON.
      //
      // `storedData` should be a variable because we're using it as fallback.
      var storedData = defaultMigrationData
      do {
        storedData = try JSONDecoder().decode(MigrationData.self, from: savedJSONData)
      } catch {
        print("error reading stored data \(error), generating default values")
      }
      
      storedDataCache = storedData
      return storedData
    }
    
    return cache
  }
  
  #warning("Can we make this function throw?")
  private func save(storedData: MigrationData) {
    storedDataCache = storedData
    do {
      try UserDefaults.standard.set(JSONEncoder().encode(storedData), forKey: key)
    } catch {
      print("failed saving data :", error)
    }
  }
}
