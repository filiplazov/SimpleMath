//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct NumberOfEquationsSettingView: View {
  @EnvironmentObject private var viewModel: SettingsViewModel
  @Environment(\.horizontalSizeClass) private var hSizeClass
  var isVisible: Bool
  
  var body: some View {
    HStack {
      VStack(spacing: 8) {
        Text(viewModel.numberOfEquations.description)
          .font(.system(size: hSizeClass.isRegular ? 54 : 40, weight: .regular))
          .animation(nil)
        
        HStack(spacing: 18) {
          Button(action: viewModel.decreaseNumberOfEquations) {
            Image(withSymbol: .minus)
              .frame(width: 60, height: 44)
              .background(Color.settingStepperBackground)
              .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
          }
          
          Button(action: viewModel.increaseNumberOfEquations) {
            Image(withSymbol: .plus)
              .frame(width: 60, height: 44)
              .background(Color.settingStepperBackground)
              .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
          }
        }
        .font(.system(size: 20))
      }
      .frame(maxWidth: .infinity)
      
      MiniDeviceView(width: hSizeClass.isRegular ? 76 : 64, animate: isVisible)
    }
    .padding(.vertical, 10)
    .padding(.horizontal)
    .modifier(SettingCell(maxWidth: .infinity))
  }
}
