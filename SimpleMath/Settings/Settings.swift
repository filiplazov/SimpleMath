//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine

protocol Settings: AnyObject {
  var currentSettings: AnyPublisher<SettingsBundle, Never> { get }
  func updateSettings(bundle: SettingsBundle)
}
