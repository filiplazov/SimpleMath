//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import CornerStacks
import SwiftUI

struct ContentView: View {
  @ObservedObject private var resultsSheet = ModalPesentation()
  @EnvironmentObject private var viewModel: SimpleMathViewModel
  @EnvironmentObject private var onboarding: Onboarding
  @State private var showSettings = false
  @State private var showResults = false
  @Environment(\.horizontalSizeClass) private var hSizeClass
  private var additionalTopPadding: CGFloat { CGFloat.screenHeight >= 736 ? 20 : 0 }
  private var progressWidth: CGFloat { (hSizeClass.isRegular ? 80 : 40) * (showSettings ? 1.5 : 1) }
  
  var body: some View {
    ZStack {
      Color.background
        .edgesIgnoringSafeArea(.all)
      
      // measuring the safe area screen
      GeometryReader { proxy in
        ZStack {
          VStack(spacing: 0) {
            Spacer()
      
            EquationsView(maxWidth: proxy.size.width)
              .padding(.bottom, self.hSizeClass.isRegular ? 130 : proxy.size.height * 0.07)
            
            // input area takes lower 40% of the screen (within safe area)
            InputView(maxWidth: proxy.size.width)
              .frame(width: proxy.size.width, height: proxy.size.height * 0.4)
          }
          .blur(radius: self.showSettings ? 20 : 0)
          .disabled(self.showSettings)

          TopLeadingHStack {
            ProgressView(
              width: self.progressWidth,
              progress: self.viewModel.progress,
              play: self.showSettings,
              pulse: self.onboarding.showSettingsHint,
              action: {
                self.onboarding.discardSettingsHint()
                self.showSettings.toggle()
              }
            )
          }
          .padding(.top, self.hSizeClass == .regular ? 24 : 10 + self.additionalTopPadding)
          .padding(.horizontal)
          
          CorrectAnswersView(correctAnswers: self.viewModel.correctAnswers)
            .padding(.top, self.hSizeClass == .regular ? 14 : 6 + self.additionalTopPadding)
            .padding(.horizontal)
            .blur(radius: self.showSettings ? 20 : 0)
        }
      }
      
      SettingsPanelView(show: $showSettings)
    }
    .onReceive(viewModel.$finished) { self.resultsSheet.isPresented = $0 }
    .onAppear { self.resultsSheet.onModalGestureDismiss(self.viewModel.reset) }
    .sheet(isPresented: $resultsSheet.isPresented) {
      ResultsView()
        .environmentObject(self.viewModel)
        .environmentObject(self.resultsSheet)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static let settingsMock: Settings = {
    let settings = SettingsMock()
    var bundle = SettingsBundle.default
    bundle.areSoundsEnabled = false
    bundle.equationsCount = 20
    settings.currentSettings = .just(bundle)
    return settings
  }()
  
  static let factoryMock = EquationsFactoryMock {
    let onePlusOne = Equation(left: 1, right: 1, operator: .add, answerDigitLimit: 1)
    let equations: [Equation] = (1...5).map{_ in onePlusOne }
    return GeneratedResult(
      equations: (1...5).map{_ in onePlusOne },
      maxOperandDigits: 1,
      maxAnswerDigits: 1
    )
  }
  
  static let finishedViewModel: SimpleMathViewModel = {
    let vm = SimpleMathViewModel(settings: settingsMock)
    for _ in vm.equations {
      vm.input(number: 1)
      vm.evaluate()
    }
    return vm
  }()
  
  static var previews: some View {
    Group {
      ContentView()
        .environmentObject(finishedViewModel)
        .previewDevice(PreviewDevice(rawValue: "iPad Air (3rd generation)"))
        .previewDisplayName("iPad Air (3rd generation)")
        .environment(\.horizontalSizeClass, .regular)
//
//      ContentView()
//        .environmentObject(SimpleMathViewModel(settings: Self.settingsMock))
//        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//        .previewDisplayName("iPhone SE")
      
      ContentView()
        .environmentObject(SimpleMathViewModel(settings: settingsMock))
        .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        .previewDisplayName("iPhone 8")
      
//      ContentView()
//        .environmentObject(SimpleMathViewModel(settings: Self.settingsMock))
//        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
//        .previewDisplayName("iPhone 11 Pro")
//      ContentView()
//        .environmentObject(SimpleMathViewModel(settings: Self.settingsMock))
//        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
//        .previewDisplayName("iPhone 11 Pro Max")
    }
  }
}










