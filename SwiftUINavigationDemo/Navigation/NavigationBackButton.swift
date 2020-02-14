import SwiftUI

struct NavigationBackButton: View {
  init(action: @escaping () -> Void) {
    self.action = action
  }

  var action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack {
        Image(systemName: "chevron.left")
          .flipsForRightToLeftLayoutDirection(true)
        Text("Back")
      }
    }
  }
}
