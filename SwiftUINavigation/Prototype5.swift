import SwiftUI
import UIKit

struct ContentView: View {
  @ObservedObject var store = Store()

  var body: some View {
    NavigationControllerView(items: $store.navigation)
      .edgesIgnoringSafeArea(.all)
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

struct RootState: NavigationItem {
  let navigationId = UUID()
}

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
  let navigationId = UUID()
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

protocol NavigationItem {
  var navigationId: UUID { get }
}

class Store: ObservableObject {
  @Published var navigation: [NavigationItem] = [RootState()]
}

// MARK: -

struct NavigationControllerView: UIViewControllerRepresentable {
  @Binding var items: [NavigationItem]

  func makeUIViewController(
    context: UIViewControllerRepresentableContext<Self>
  ) -> UINavigationController {
    let navigationController = UINavigationController()
    navigationController.delegate = context.coordinator
    return navigationController
  }

  func updateUIViewController(
    _ navigationController: UINavigationController,
    context: UIViewControllerRepresentableContext<Self>
  ) {
    let viewControllers = navigationController.viewControllers
      .compactMap { $0 as? NavigationItemController }
    let newViewControllers = items.map { item -> NavigationItemController in
      let itemView = viewFactory(item)
      let viewController = viewControllers.first { $0.navigationId == item.navigationId }
      viewController?.rootView = itemView
      return viewController
        ?? NavigationItemController(navigationId: item.navigationId, view: itemView)
    }
    let presentedStack = viewControllers.map { $0.navigationId }
    let stateStack = newViewControllers.map { $0.navigationId }
    if presentedStack != stateStack {
      let animate = !viewControllers.isEmpty
      navigationController.setViewControllers(newViewControllers, animated: animate)
    }
  }

  func makeCoordinator() -> NavigationCoordinator {
    NavigationCoordinator(self)
  }
}

class NavigationCoordinator: NSObject, UINavigationControllerDelegate {
  init(_ view: NavigationControllerView) {
    self.view = view
    super.init()
  }
  let view: NavigationControllerView

  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    let viewControllers = navigationController.viewControllers
      .compactMap { $0 as? NavigationItemController }
    let presentedStack = viewControllers.map { $0.navigationId }
    let stateStack = view.items.map { $0.navigationId }
    if stateStack != presentedStack {
      view.items = viewControllers.map { $0.navigationId }.compactMap { navigationId in
        view.items.first { $0.navigationId == navigationId }
      }
    }
  }
}

class NavigationItemController: UIHostingController<AnyView> {
  init(navigationId: UUID, view: AnyView) {
    self.navigationId = navigationId
    super.init(rootView: view)
  }
  required init?(coder aDecoder: NSCoder) { nil }
  let navigationId: UUID
}

let viewFactory: (NavigationItem) -> AnyView = { navigationItem in
  switch navigationItem {
  case let state as RootState:
    return AnyView(RootView(state: state))
  case let state as StepState:
    return AnyView(StepView(state: state))
  default:
    fatalError()
  }
}
