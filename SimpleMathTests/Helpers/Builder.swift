//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

@testable import SimpleMath
import Foundation

protocol Builder {}

extension Builder {
  func set<T>(_ keyPath: WritableKeyPath<Self, T>, to newValue: T) -> Self {
    var copy = self
    copy[keyPath: keyPath] = newValue
    return copy
  }
}

extension SettingsBundle: Builder {}
extension EquationSettings: Builder {}
