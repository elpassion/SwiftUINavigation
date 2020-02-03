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

struct RootState: NavigationItem {}

struct RootView: View {
  @EnvironmentObject var store: Store
  let state: RootState
  var body: some View {
    VStack(spacing: 16) {
      Text("Root").font(.title)
      Button(action: {
        self.store.navigation.append(StepState(step: 1))
      }) { Text("Go to first step →") }
    }
  }
}

struct StepState: NavigationItem {
  let step: Int
}

struct StepView: View {
  @EnvironmentObject var store: Store
  let state: StepState
  var body: some View {
    VStack(spacing: 16) {
      Text("Step #\(state.step)").font(.title)
      if state.step < 3 {
        Button(action: {
          self.store.navigation.append(StepState(step: self.state.step + 1))
        }) { Text("Go to next step →") }
      } else {
        Text("Done")
      }
      Button(action: {
        self.store.navigation.removeLast(self.store.navigation.count - 1)
      }) { Text("← Go back to root") }
    }
  }
}

// MARK: -

protocol NavigationItem {}

class Store: ObservableObject {
  @Published var navigation: [NavigationItem] = []
}
