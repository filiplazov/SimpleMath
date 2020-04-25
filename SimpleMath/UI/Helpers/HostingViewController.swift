//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

class HostingController<Content>: UIHostingController<Content> where Content: View {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
