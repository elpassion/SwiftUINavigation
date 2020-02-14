import SwiftUI

struct NavigationStackView: View {
  init(items: [NavigationItem], viewFactory: @escaping NavigationItemViewFactory) {
    self.items = items
    self.viewFactory = viewFactory
  }

  var items: [NavigationItem]
  var viewFactory: NavigationItemViewFactory

  var body: some View {
    ZStack {
      EmptyView()
      ForEach(Array(items.enumerated()), id: \.element.navigationId) { index, item in
        Group {
          self.itemBackground()
            .zIndex(Double(index) - 0.1)
          self.itemView(for: item)
            .allowsHitTesting(index == self.items.index(before: self.items.endIndex))
            .zIndex(Double(index))
        }
      }
    }
  }

  func itemBackground() -> some View {
    Color.black.opacity(0.2)
      .edgesIgnoringSafeArea(.all)
      .allowsHitTesting(false)
      .transition(.asymmetric(
        insertion: AnyTransition.opacity.animation(.easeInOut(duration: 0.2)),
        removal: AnyTransition.opacity.animation(.easeInOut(duration: 0.3))))
  }

  func itemView(for item: NavigationItem) -> some View {
    self.viewFactory(item)
      .animation(.easeInOut(duration: 0.25))
      .transition(.move(edge: .trailing))
  }
}
