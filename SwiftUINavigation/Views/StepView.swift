import SwiftUI

struct StepView: View {
  init(state: StepState) {
    self.state = state
  }

  var state: StepState
  @EnvironmentObject var store: Store

  var body: some View {
    NavigationItemView(navigationBar: {
      NavigationBarView(title: {
        Text("Step \(state.step)").font(.headline)
      }, leadingView: {
        NavigationBackButton {
          _ = self.store.navigation.removeLast()
        }
      }, trailingView: {
        EmptyView()
      })
    }) {
      VStack(spacing: 16) {
        Text("Step #\(state.step)").font(.title)
        HStack {
          Button(action: {
            self.store.navigation = self.store.navigation.map { item in
              guard item.navigationId == self.state.navigationId else { return item }
              var state = self.state
              state.counter -= 1
              return state
            }
          }) {
            Image(systemName: "minus.circle")
              .font(.system(size: 22))
          }.padding()
          Text("  \(state.counter)  ")
            .frame(width: 128)
          Button(action: {
            self.store.navigation = self.store.navigation.map { item in
              guard item.navigationId == self.state.navigationId else { return item }
              var state = self.state
              state.counter += 1
              return state
            }
          }) {
            Image(systemName: "plus.circle.fill")
              .font(.system(size: 22))
          }.padding()
        }
        if state.step < 3 {
          Button(action: {
            self.store.navigation.append(StepState(step: self.state.step + 1))
          }) { Text("Go to next step →") }
        } else {
          Text("Done")
        }
        Button(action: {
          self.store.navigation = [self.store.navigation.first].compactMap { $0 }
        }) { Text("← Go back to root") }
      }
    }.navigationBackGesture(action: {
      _ = self.store.navigation.removeLast()
    })
  }
}
