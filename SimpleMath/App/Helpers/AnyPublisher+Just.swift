//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine

extension AnyPublisher {
  static func just<Output>(_ value: Output) -> AnyPublisher<Output, Never> {
    Just<Output>(value).eraseToAnyPublisher()
  }
}
