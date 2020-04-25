//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine

// This is a workaround to avoid strong self capturing (and causing retain cycle) when using assign on self
// and storing subscription in self
// https://forums.swift.org/t/does-assign-to-produce-memory-leaks/29546

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
       sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}
