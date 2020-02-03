import SwiftUI
import UIKit

struct ContentView: View {
  var body: some View {
    Text("Hello World")
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif

// MARK: -

struct RootState {}

struct RootView: View {
  let state: RootState
  var body: some View {
    VStack(spacing: 16) {
      Text("Root").font(.title)
      Button(action: {
        // TODO: navigate to first step
      }) { Text("Go to first step →") }
    }
  }
}

struct StepState {
  let step: Int
}

struct StepView: View {
  let state: StepState
  var body: some View {
    VStack(spacing: 16) {
      Text("Step #\(state.step)").font(.title)
      if state.step < 3 {
        Button(action: {
          // TODO: navigate to next step
        }) { Text("Go to next step →") }
      } else {
        Text("Done")
      }
      Button(action: {
        // TODO: navigate to root
      }) { Text("← Go back to root") }
    }
  }
}
