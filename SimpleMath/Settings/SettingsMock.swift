//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine

final class SettingsMock: Settings {
  var updatedBundle: SettingsBundle?
  var currentSettings: AnyPublisher<SettingsBundle, Never> = Empty<SettingsBundle, Never>()
    .eraseToAnyPublisher()

  func updateSettings(bundle: SettingsBundle) {
    self.updatedBundle = bundle
  }

}
