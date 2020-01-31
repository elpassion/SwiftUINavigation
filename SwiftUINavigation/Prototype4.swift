import SwiftUI
import UIKit

struct ContentView: View {
  @ObservedObject var store = Store()

  var body: some View {
    NavigationControllerView(
      navigationItems: $store.navigation,
      controllerFactory: UINavigationController.init,
      itemControllerFactory: NavigationItemController.init,
      itemViewFactory: navigationItemViewFactory
    ).edgesIgnoringSafeArea(.all)
      .environmentObject(store)
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

class Store: ObservableObject {
  @Published var navigation: [NavigationItem] = [RootState()]
}

struct RootState: NavigationItem {
  let navigationId = UUID()
}

struct StepState: NavigationItem {
  let navigationId = UUID()
  let step: Int
}

// MARK: -

struct RootView: View {
  init(state: RootState) {
    self.state = state
  }

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

struct StepView: View {
  init(state: StepState) {
    self.state = state
  }

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
        self.store.navigation = [self.store.navigation.first].compactMap { $0 }
      }) { Text("← Go back to root") }
    }
  }
}

let navigationItemViewFactory = combine(
  optional(RootView.init(state:)),
  optional(StepView.init(state:))
)

// MARK: -

protocol NavigationItem {
  var navigationId: UUID { get }
}

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

struct NavigationControllerView: UIViewControllerRepresentable {
  typealias NavigationControllerFactory = () -> UINavigationController
  typealias ViewControllerFactory = (UUID, AnyView) -> NavigationItemControlling

  @Binding var navigationItems: [NavigationItem]
  let controllerFactory: NavigationControllerFactory
  let itemControllerFactory: ViewControllerFactory
  let itemViewFactory: NavigationItemViewFactory

  func makeUIViewController(
    context: UIViewControllerRepresentableContext<Self>
  ) -> UINavigationController {
    let navigationController = controllerFactory()
    navigationController.delegate = context.coordinator
    return navigationController
  }

  func updateUIViewController(
    _ navigationController: UINavigationController,
    context: UIViewControllerRepresentableContext<Self>
  ) {
    let viewControllers = navigationController.navigationItemControllers
    let newViewControllers = navigationItems.map { navigationItem -> NavigationItemControlling in
      let itemView = itemViewFactory(navigationItem)
      let viewController = viewControllers.first { $0.navigationId == navigationItem.navigationId }
      viewController?.rootView = itemView
      return viewController ?? itemControllerFactory(navigationItem.navigationId, itemView)
    }
    let presentedStack = viewControllers.map { $0.navigationId }
    let currentStack = newViewControllers.map { $0.navigationId }
    if presentedStack != currentStack {
      let animate = !viewControllers.isEmpty
      navigationController.setViewControllers(newViewControllers, animated: animate)
    }
  }

  func makeCoordinator() -> NavigationControllerCoordinator {
    NavigationControllerCoordinator(self)
  }
}

class NavigationControllerCoordinator: NSObject, UINavigationControllerDelegate {

  init(_ view: NavigationControllerView) {
    self.view = view
  }

  let view: NavigationControllerView

  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    let viewControllers = navigationController.navigationItemControllers
    let presentedStack = viewControllers.map { $0.navigationId }
    let currentStack = view.navigationItems.map { $0.navigationId }
    if currentStack != presentedStack {
      view.navigationItems = viewControllers.map { $0.navigationId }.compactMap { navigationId in
        view.navigationItems.first { $0.navigationId == navigationId }
      }
    }
  }

}

extension UINavigationController {
  var navigationItemControllers: [NavigationItemControlling] {
    viewControllers.compactMap { $0 as? NavigationItemControlling }
  }
}

protocol NavigationItemControlling: UIHostingController<AnyView> {
  var navigationId: UUID { get }
}

class NavigationItemController: UIHostingController<AnyView>, NavigationItemControlling {

  init<Content: View>(navigationId: UUID, content: Content) {
    self.navigationId = navigationId
    super.init(rootView: AnyView(content))
  }

  required init?(coder aDecoder: NSCoder) { nil }

  let navigationId: UUID

}
