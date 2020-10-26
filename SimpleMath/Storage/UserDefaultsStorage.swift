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
    var data = storedData
    data.settingsBundle = settingsBundle
    save(storedData: data)
  }

  func loadSettingsBundle() -> SettingsBundle {
    storedData.settingsBundle
  }

  func store(onboardingBundle: OnboardingBundle) {
    var data = storedData
    data.onboardingBundle = onboardingBundle
    save(storedData: data)
  }

  func loadOnboardingBundle() -> OnboardingBundle {
    storedData.onboardingBundle
  }
  
  #warning("Documentation needs work.")
  #warning("Who is calling `storedData`? Why is it private?")
  /// What data?
  /// - The cache, if available.
  /// - If the cache is not available, try from UserDefaults
  /// - If UserDefaults doesn't have any data, then return `defaultStoreData`
  ///
  /// - Returns: a Store Data object?
  private var storedData: StoredData {
    
    // Do we have a cache?
    guard let cache = storedDataCache else {
      
      // We do not. Do we have the previous data in UserDefaults?
      guard let savedJSONData = UserDefaults.standard.value(forKey: key) as? Data else {
        // We don't have previous data.
        // Generate it.
        print("No data found for key \(key), generating default values")
        storedDataCache = defaultStoreData
        #warning("We should save this to UserDefaults.")
        return storedDataCache!
      }
      
      // We do have the previous data in UserDefaults.
      // Transform it into a JSON.
      var storedData = defaultStoreData
      do {
        storedData = try JSONDecoder().decode(StoredData.self, from: savedJSONData)
      } catch {
        print("error reading stored data \(error), generating default values")
      }
      
      storedDataCache = storedData
      return storedData
    }
    
    return cache
  }
  
  private var defaultStoreData: StoredData {
    var storedData = StoredData.useDefault
    storedData.modelVersion = modelVersion
    return storedData
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
