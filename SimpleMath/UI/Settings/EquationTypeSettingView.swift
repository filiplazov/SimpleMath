//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct EquationTypeSettingView: View {
  @EnvironmentObject private var viewModel: SettingsViewModel
  
  var body: some View {
    VStack(alignment: .center, spacing: 16) {
      EquationTypeRow(
        description: "X + Y = ",
        isEnabled: viewModel.additionEnabled,
        enable: { self.viewModel.enableEquation(type: .addition) },
        disable: { self.viewModel.disableEquation(type: .addition)}
      )
      EquationTypeRow(
        description: "X - Y = ",
        isEnabled: viewModel.subtractonEnabled,
        enable: { self.viewModel.enableEquation(type: .subtraction) },
        disable: { self.viewModel.disableEquation(type: .subtraction)}
      )
      EquationTypeRow(
        description: "X × Y = ",
        isEnabled: viewModel.multiplicationEnabled,
        enable: { self.viewModel.enableEquation(type: .multiplication) },
        disable: { self.viewModel.disableEquation(type: .multiplication)}
      )
      EquationTypeRow(
        description: "X ÷ Y = ",
        isEnabled: viewModel.divisionEnabled,
        enable: { self.viewModel.enableEquation(type: .division) },
        disable: { self.viewModel.disableEquation(type: .division)}
      )
    }
    .padding()
    .modifier(SettingCell(maxWidth: .infinity))
  }
}

private struct EquationTypeRow: View {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  var description: String
  var isEnabled: Bool
  var enable: () -> Void
  var disable: () -> Void
  
  var body: some View {
    HStack {
      Image(withSymbol: isEnabled ? .checkmarkFilled : .checkmark)
        .foregroundColor(isEnabled ? .settingEquationEnabled : Color.settingEquationDisabled.opacity(0.5))
        .font(.system(size: hSizeClass.isRegular ? 26 : 20))
      Text(description)
        .font(.system(size: hSizeClass.isRegular ? 28 : 20, weight: .regular, design: .monospaced))
        .padding(.leading, 22)
      Text("  ")
        .font(.system(size: hSizeClass.isRegular ? 28 : 20, weight: .regular, design: .monospaced))
        .frame(width: hSizeClass.isRegular ? 56 : 46)
        .background(Color.unanswered)
        .clipShape(Capsule())
    }
    .onTapGesture {
      self.isEnabled ? self.disable() : self.enable()
    }
    .frame(maxWidth: .infinity)
  }
}
