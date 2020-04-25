//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine

final class StoredSettings: Settings {
  private var publishSettings: CurrentValueSubject<SettingsBundle, Never>
  private var storage: Storage

  var currentSettings: AnyPublisher<SettingsBundle, Never> {
    publishSettings.eraseToAnyPublisher()
  }

  init(withStorage storage: Storage) {
    self.storage = storage
    let settingsBundle = storage.loadSettingsBundle()
    publishSettings = .init(settingsBundle)
  }

  func updateSettings(bundle: SettingsBundle) {
    guard bundle != publishSettings.value else { return }
    storage.store(settingsBundle: bundle)
    publishSettings.value = bundle
  }
}
