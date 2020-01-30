//import SwiftUI
//import UIKit
//
//struct ContentView: View {
//  @ObservedObject var store = Store(AppState())
//
//  var body: some View {
//    NavigationControllerRepresentation(items: $store.state.navigation)
//      .edgesIgnoringSafeArea(.all)
//      .environmentObject(store)
//  }
//}
//
//struct OnboardingNavigationItem: NavigationItem {
//  let id = UUID()
//
//  func makeView() -> AnyView {
//    AnyView(OnboardingView())
//  }
//}
//
//struct OnboardingView: View {
//  @EnvironmentObject var store: Store<AppState>
//
//  var body: some View {
//    VStack(spacing: 16) {
//      Text("Onboarding")
//      Button(action: { self.store.state.navigation.append(LogInNavigationItem()) }) {
//        Text("Log In →")
//      }
//    }
//  }
//}
//
//struct LogInNavigationItem: NavigationItem {
//  let id = UUID()
//
//  func makeView() -> AnyView {
//    AnyView(LogInView())
//  }
//}
//
//struct LogInView: View {
//  @EnvironmentObject var store: Store<AppState>
//
//  var body: some View {
//    VStack(spacing: 16) {
//      Text("Log In")
//      Button(action: { self.store.state.navigation.append(SignUpNavigationItem()) }) {
//        Text("Sign Up →")
//      }
//    }
//  }
//}
//
//struct SignUpNavigationItem: NavigationItem {
//  let id = UUID()
//
//  func makeView() -> AnyView {
//    AnyView(SignUpView())
//  }
//}
//
//struct SignUpView: View {
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
//struct AppState /*: Codable !!! */ {
//  var navigation: [NavigationItem] = [OnboardingNavigationItem()]
//}
//
////struct Parent: Codable { var children: [Child] }
////protocol Child: Codable {}
////struct Kid: Child {}
//
//// MARK: -
//
//protocol NavigationItem: Codable {
//  var id: UUID { get }
//  func makeView() -> AnyView
//}
//
//struct NavigationControllerRepresentation: UIViewControllerRepresentable {
//  @Binding var items: [NavigationItem]
//
//  func makeUIViewController(
//    context: UIViewControllerRepresentableContext<Self>
//  ) -> NavigationController {
//    let navigationController = NavigationController()
//    navigationController.delegate = context.coordinator
//    return navigationController
//  }
//
//  func updateUIViewController(
//    _ navigationController: NavigationController,
//    context: UIViewControllerRepresentableContext<Self>
//  ) {
//    let viewControllers = navigationController.viewControllers
//      .compactMap { $0 as? NavigationItemViewController }
//    let presentedStack = viewControllers.map { $0.item.id }
//    let currentStack = items.map { $0.id }
//    guard presentedStack != currentStack else {
//      return
//    }
//    let newViewControllers = items.map { item in
//      viewControllers.first(where: { $0.item.id == item.id })
//        ?? NavigationItemViewController(item: item)
//    }
//    let animate = !navigationController.viewControllers.isEmpty
//    navigationController.setViewControllers(newViewControllers, animated: animate)
//  }
//
//  func makeCoordinator() -> Coordinator {
//    Coordinator(items: $items)
//  }
//
//}
//
//extension NavigationControllerRepresentation {
//  class NavigationController: UINavigationController {
//
//  }
//
//  class NavigationItemViewController: UIHostingController<AnyView> {
//
//    init(item: NavigationItem) {
//      self.item = item
//      super.init(rootView: item.makeView())
//    }
//
//    required init?(coder aDecoder: NSCoder) { nil }
//
//    let item: NavigationItem
//
//  }
//}
//
//extension NavigationControllerRepresentation {
//  class Coordinator: NSObject, UINavigationControllerDelegate {
//
//    init(items: Binding<[NavigationItem]>) {
//      self._items = items
//    }
//
//    @Binding var items: [NavigationItem]
//
//    func navigationController(
//      _ navigationController: UINavigationController,
//      didShow viewController: UIViewController,
//      animated: Bool
//    ) {
//      let viewControllers = navigationController.viewControllers
//        .compactMap { $0 as? NavigationItemViewController }
//      let presentedStack = viewControllers.map { $0.item.id }
//      let currentStack = items.map { $0.id }
//      guard currentStack != presentedStack else {
//        return
//      }
//      items = viewControllers.map { $0.item }
//    }
//
//  }
//}
