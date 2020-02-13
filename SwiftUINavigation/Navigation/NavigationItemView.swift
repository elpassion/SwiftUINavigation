import SwiftUI

struct NavigationItemView<NavigationBar: View, Content: View>: View {
  init(@ViewBuilder navigationBar: () -> NavigationBar,
                    @ViewBuilder content: () -> Content) {
    self.navigationBar = navigationBar()
    self.content = content()
  }
  
  var navigationBar: NavigationBar
  var content: Content
  
  var body: some View {
    ZStack(alignment: .top) {
      Color(UIColor.systemBackground)
        .edgesIgnoringSafeArea(.all)
      VStack(spacing: 0) {
        navigationBar
        ZStack {
          content
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}
