import SwiftUI

typealias NavigationItemViewFactory = (NavigationItem) -> AnyView
typealias TypedNavigationItemViewFactory<I: NavigationItem, V: View> = (I) -> V
typealias OptionalNavigationItemViewFactory = (NavigationItem) -> AnyView?

func optional<Item, View>(
  _ factory: @escaping TypedNavigationItemViewFactory<Item, View>
) -> OptionalNavigationItemViewFactory {
  { item in (item as? Item).map(factory).map(AnyView.init) }
}

func combine(
  _ factories: OptionalNavigationItemViewFactory...
) -> NavigationItemViewFactory {
  { item in
    for factory in factories {
      if let view = factory(item) {
        return view
      }
    }
    fatalError("NavigationItemViewFactory not found for item: \(item)")
  }
}
