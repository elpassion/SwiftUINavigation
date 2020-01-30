//import SwiftUI
//import UIKit
//
//struct ContentView: View {
//  @ObservedObject var store = Store(AppState())
//
//  var body: some View {
//    NavigationControllerRepresentation(
//      factory: NavigationController.init,
//      items: $store.state.navigation
//    ).edgesIgnoringSafeArea(.all)
//      .environmentObject(store)
//  }
//}
//
//struct OnboardingView: View {
//  struct State: NavigationItem {
//    let navigationId = UUID()
//
//    func makeView() -> AnyView {
//      AnyView(OnboardingView())
//    }
//  }
//
//  @EnvironmentObject var store: Store<AppState>
//
//  var body: some View {
//    VStack(spacing: 16) {
//      Text("Onboarding")
//      Button(action: {
//        self.store.state.navigation.append(LogInView.State())
//      }) {
//        Text("Log In →")
//      }
//    }
//  }
//}
//
//struct LogInView: View {
//  struct State: NavigationItem {
//    let navigationId = UUID()
//
//    func makeView() -> AnyView {
//      AnyView(LogInView())
//    }
//  }
//
//  @EnvironmentObject var store: Store<AppState>
//
//  var body: some View {
//    VStack(spacing: 16) {
//      Text("Log In")
//      Button(action: {
//        self.store.state.navigation.append(SignUpView.State())
//      }) {
//        Text("Sign Up →")
//      }
//    }
//  }
//}
//
//struct SignUpView: View {
//  struct State: NavigationItem {
//    let navigationId = UUID()
//
//    func makeView() -> AnyView {
//      AnyView(SignUpView())
//    }
//  }
//
//  @EnvironmentObject var store: Store<AppState>
//
//  var body: some View {
//    VStack(spacing: 16) {
//      Text("Sign Up")
//      Button(action: {
//        self.store.state.navigation = [self.store.state.navigation.first].compactMap { $0 }
//      }) {
//        Text("← Onboarding")
//      }
//    }
//  }
//}
//
//// MARK: -
//
//class Store<State>: ObservableObject {
//
//  init(_ state: State) {
//    self.state = state
//  }
//
//  @Published var state: State {
//    didSet { print("^^^ \(state)") }
//  }
//
//}
//
//struct AppState {
//  var navigation: [NavigationItem] = [OnboardingView.State()]
//}
//
//// MARK: -
//
//protocol NavigationItem {
//  var navigationId: UUID { get }
//  func makeView() -> AnyView
//}
//
//struct NavigationControllerRepresentation: UIViewControllerRepresentable {
//  let factory: () -> UINavigationController
//  @Binding var items: [NavigationItem]
//
//  func makeUIViewController(
//    context: UIViewControllerRepresentableContext<Self>
//  ) -> UINavigationController {
//    let navigationController = self.factory()
//    navigationController.delegate = context.coordinator
//    return navigationController
//  }
//
//  func updateUIViewController(
//    _ navigationController: UINavigationController,
//    context: UIViewControllerRepresentableContext<Self>
//  ) {
//    let viewControllers = navigationController.viewControllers
//      .compactMap { $0 as? NavigationItemController }
//    let newViewControllers = items.map { item -> NavigationItemController in
//      let viewController = viewControllers.first { $0.item.navigationId == item.navigationId }
//      viewController?.item = item
//      return viewController ?? NavigationItemController(item)
//    }
//    let presentedStack = viewControllers.map { $0.item.navigationId }
//    let currentStack = items.map { $0.navigationId }
//    guard presentedStack != currentStack else { return }
//    let animate = !viewControllers.isEmpty
//    navigationController.setViewControllers(newViewControllers, animated: animate)
//  }
//
//  func makeCoordinator() -> NavigationControllerCoordinator {
//    NavigationControllerCoordinator($items)
//  }
//}
//
//class NavigationControllerCoordinator: NSObject, UINavigationControllerDelegate {
//
//  init(_ items: Binding<[NavigationItem]>) {
//    self._items = items
//    super.init()
//  }
//
//  @Binding var items: [NavigationItem]
//
//  func navigationController(
//    _ navigationController: UINavigationController,
//    didShow viewController: UIViewController,
//    animated: Bool
//  ) {
//    items = navigationController.viewControllers
//      .compactMap { $0 as? NavigationItemController }
//      .map { $0.item }
//  }
//
//}
//
//class NavigationController: UINavigationController {
//
//}
//
//class NavigationItemController: UIHostingController<AnyView> {
//
//  init(_ item: NavigationItem) {
//    self.item = item
//    super.init(rootView: item.makeView())
//  }
//
//  required init?(coder: NSCoder) { nil }
//
//  var item: NavigationItem
//
//}
