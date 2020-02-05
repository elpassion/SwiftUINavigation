import SwiftUI
import UIKit

struct ContentView: View {
  @ObservedObject var store: Store = Store()

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

struct RootState: NavigationItem {}

struct RootView: View {
  @EnvironmentObject var store: Store
  let state: RootState
  var body: some View {
    VStack(spacing: 16) {
      Text("Root").font(.title)
      Button(action: {
        self.store.navigation.append(StepState(step: 1))
      }) {
        Text("Go to first step →")
      }
    }
  }
}

struct StepState: NavigationItem {
  let step: Int
}

struct StepView: View {
  @EnvironmentObject var store: Store
  let state: StepState
  var body: some View {
    VStack(spacing: 16) {
      Text("Step \(state.step)").font(.title)
      if state.step < 2 {
        Button(action: {
          self.store.navigation.append(StepState(step: self.state.step + 1))
        }) {
          Text("Go to next step →")
        }
      } else {
        Text("Done")
      }
      Button(action: {
        self.store.navigation.removeLast(self.store.navigation.count - 1)
      }) {
        Text("← Go back to root")
      }
    }
  }
}

// MARK: -

protocol NavigationItem {}

class Store: ObservableObject {
  @Published var navigation: [NavigationItem] = [RootState()] {
    didSet {
      print("^^^ \(navigation)")
    }
  }
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
      .compactMap { $0 as? UIHostingController<AnyView> }
    let newViewControllers = items.enumerated().map { (index, item) -> UIHostingController<AnyView> in
      let itemView = viewFactory(item)
      if (viewControllers.startIndex..<viewControllers.endIndex).contains(index) {
        let viewController = viewControllers[index]
        viewController.rootView = itemView
        return viewController
      }
      return UIHostingController(rootView: itemView)
    }
    if viewControllers.count != newViewControllers.count {
      let animate = !viewControllers.isEmpty
      navigationController.setViewControllers(newViewControllers, animated: animate)

    }
  }

  func makeCoordinator() -> NavigationCoordinator {
    NavigationCoordinator(view: self)
  }
}

class NavigationCoordinator: NSObject, UINavigationControllerDelegate {

  init(view: NavigationControllerView) {
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
    if viewControllers.count != view.items.count {
      view.items = zip(view.items, viewControllers).map { $0.0 }
    }
  }
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
