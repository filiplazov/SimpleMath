//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct SoundToggleSettingView: View {
  @EnvironmentObject private var viewModel: SettingsViewModel
  @Environment(\.horizontalSizeClass) private var hSizeClass

  var body: some View {
    HStack {
      Image(withSymbol: viewModel.areSoundsEnabled ? .soundsEnabled : .soundsDisabled)
      .font(.system(size: hSizeClass.isRegular ? 26 : 20))
      Toggle(
        isOn: Binding<Bool>(
          get: { self.viewModel.areSoundsEnabled },
          set: { self.viewModel.updateSoundsEnabled(to: $0) }
        ),
        label: { EmptyView() }
      )
    }
    .padding()
    .modifier(SettingCell(maxWidth: .infinity))
  }
}
