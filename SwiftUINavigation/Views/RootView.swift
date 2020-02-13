import SwiftUI

struct RootView: View {
  init(state: RootState) {
    self.state = state
  }

  var state: RootState
  @EnvironmentObject var store: Store

  var body: some View {
    NavigationItemView(navigationBar: { EmptyView() }, content: {
      VStack(spacing: 16) {
        Text("Root").font(.title)
        Button(action: {
          self.store.navigation.append(StepState(step: 1))
        }) { Text("Go to first step →") }
      }
    })
  }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView(state: RootState())
      .environmentObject(Store())
  }
}
#endif
