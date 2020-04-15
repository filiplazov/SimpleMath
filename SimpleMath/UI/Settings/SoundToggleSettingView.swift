//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct SoundToggleSettingView: View {
  @EnvironmentObject private var viewModel: SettingsViewModel
  
  var body: some View {
    HStack {
      Image(withSymbol: viewModel.areSoundsEnabled ? .soundsEnabled : .soundsDisabled)
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
