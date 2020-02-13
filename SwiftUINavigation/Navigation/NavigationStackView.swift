import SwiftUI

struct NavigationStackView: View {
  init(items: Binding<[NavigationItem]>, viewFactory: @escaping NavigationItemViewFactory) {
    self._items = items
    self.viewFactory = viewFactory
  }

  @Binding var items: [NavigationItem]
  var viewFactory: NavigationItemViewFactory

  var body: some View {
    ZStack {
      EmptyView()
      ForEach(Array(items.enumerated()), id: \.element.navigationId) { index, item in
        Group {
          Color.black.opacity(0.2)
            .edgesIgnoringSafeArea(.all)
            .allowsHitTesting(false)
            .transition(.asymmetric(
              insertion: AnyTransition.opacity.animation(.easeInOut(duration: 0.2)),
              removal: AnyTransition.opacity.animation(.easeInOut(duration: 0.3))))
            .zIndex(Double(index) - 0.1)
          self.viewFactory(item)
            .allowsHitTesting(index == self.items.index(before: self.items.endIndex))
            .animation(.easeInOut(duration: 0.25))
            .transition(.move(edge: .trailing))
            .zIndex(Double(index))
        }
      }
    }
  }
}
