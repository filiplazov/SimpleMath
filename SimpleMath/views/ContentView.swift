//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import CornerStacks
import SwiftUI

struct ContentView: View {
  @State private var showResults = false
  @ObservedObject var viewModel: SimpleMathViewModel
  
    var body: some View {
      ZStack {
        VStack {
          EquationsView(viewModel: viewModel)
          Spacer()
          InputView(viewModel: viewModel)
        }
        TopLeadingHStack {
          ProgressView(progress: self.viewModel.progress)
        }
        CorrectAnswersView(correctAnswers: viewModel.correctAnswers)
      }
      .onReceive(viewModel.$finished) { finished in
        self.showResults = finished
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .background(Color(#colorLiteral(red: 0.4739681945, green: 0.1025257594, blue: 0.4670193102, alpha: 1)))
      .edgesIgnoringSafeArea(.all)
      .sheet(isPresented: $showResults) {
        ResultsView(viewModel: self.viewModel)
      }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView(viewModel: SimpleMathViewModel())
    }
}

extension View {
  func blackBorder() -> some View {
    self.border(Color.black)
  }
  func redBorder() -> some View {
    self.border(Color.red)
  }
}
