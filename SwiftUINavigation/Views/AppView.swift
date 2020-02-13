import SwiftUI

struct AppView: View {
  @EnvironmentObject var store: Store

  var body: some View {
    NavigationStackView(
      items: $store.navigation,
      viewFactory: navigationItemViewFactory
    )
  }
}

#if DEBUG
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView().environmentObject(Store())
  }
}
#endif
