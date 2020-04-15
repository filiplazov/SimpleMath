//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

struct OnboardingBundle: Equatable, Codable {
  var seenSettingsHint: Bool
}

extension OnboardingBundle {
  static var `default`: OnboardingBundle {
    OnboardingBundle(seenSettingsHint: false)
  }
}
