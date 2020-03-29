//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import CornerStacks
import SwiftUI

struct ContentView: View {
  @State private var screenSize: CGSize = .zero
  @State private var showResults = false
  @Environment(\.horizontalSizeClass) private var hSizeClass
  private var additionalTopPadding: CGFloat { screenSize.height > 700 ? 20 : 0 }
  @ObservedObject var viewModel: SimpleMathViewModel
  
  var body: some View {
    ZStack {
      Color(#colorLiteral(red: 0.4739681945, green: 0.1025257594, blue: 0.4670193102, alpha: 1))
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .edgesIgnoringSafeArea(.all)
      
      GeometryReader { screenProxy in
        VStack(spacing: 0) {
          Spacer()
          
          EquationsView(viewModel: self.viewModel, maxWidth: screenProxy.size.width)
            .padding(.bottom, self.hSizeClass.isRegular ? 130 : screenProxy.size.height * 0.07)
          
          // input area takes lower 40% of the screen (within safe area)
          InputView(viewModel: self.viewModel)
            .frame(width: screenProxy.size.width, height: screenProxy.size.height * 0.4)
        }
        .onAppear {
          self.screenSize = screenProxy.size
        }
      }
      
      TopLeadingHStack {
        ProgressView(width: self.hSizeClass.isRegular ? 80 : 40, progress: self.viewModel.progress)
      }
      .padding(.top, self.hSizeClass == .regular ? 24 : 10 + additionalTopPadding)
      .padding(.horizontal)
      
      CorrectAnswersView(correctAnswers: viewModel.correctAnswers)
        .padding(.top, self.hSizeClass == .regular ? 14 : 6 + additionalTopPadding)
        .padding(.horizontal)
        
    }
    .onReceive(viewModel.$finished) { finished in
      self.showResults = finished
    }
    .sheet(isPresented: $showResults) {
      ResultsView(viewModel: self.viewModel)
    }
  }
  
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView(viewModel: SimpleMathViewModel())
        .previewDevice(PreviewDevice(rawValue: "iPad Air (3rd generation)"))
        .previewDisplayName("iPad Air (3rd generation)")
        .environment(\.horizontalSizeClass, .regular)
      
      ContentView(viewModel: SimpleMathViewModel())
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        .previewDisplayName("iPhone SE")
      
      ContentView(viewModel: SimpleMathViewModel())
        .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        .previewDisplayName("iPhone 8")
      
      ContentView(viewModel: SimpleMathViewModel())
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
        .previewDisplayName("iPhone 11 Pro")
      ContentView(viewModel: SimpleMathViewModel())
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
        .previewDisplayName("iPhone 11 Pro Max")
    }
  }
}
