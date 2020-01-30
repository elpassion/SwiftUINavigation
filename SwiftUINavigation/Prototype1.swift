//import SwiftUI
//import UIKit
//
//struct ContentView: View {
//  @State var stack: [NavigationItem] = [NavigationItem(title: "Root")]
//
//  var body: some View {
//    NavigationControllerRepresentable(items: $stack).edgesIgnoringSafeArea(.all)
//  }
//}
//
//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//  }
//}
//#endif
//
//struct NavigationItem {
//  let id = UUID()
//  var title: String
//}
//
//struct NavigationItemView: View {
//  let item: NavigationItem
//  @Binding var items: [NavigationItem]
//
//  var body: some View {
//    VStack(spacing: 16) {
//      Text(item.title)
//      Button(action: { self.items.append(NavigationItem(title: "Pushed \(self.items.count)")) }) {
//        Text("Push →")
//      }
//    }.navigationBarTitle("\(item.title)", displayMode: .inline)
//  }
//}
//
//struct NavigationControllerRepresentable: UIViewControllerRepresentable {
//  @Binding var items: [NavigationItem]
//
//  func makeUIViewController(
//    context: UIViewControllerRepresentableContext<Self>
//  ) -> UINavigationController {
//    let navigationController = UINavigationController()
//    navigationController.delegate = context.coordinator
//    return navigationController
//  }
//
//  func updateUIViewController(
//    _ navigationController: NavigationControllerRepresentable.UIViewControllerType,
//    context: UIViewControllerRepresentableContext<NavigationControllerRepresentable>
//  ) {
//    let viewControllers = navigationController.viewControllers.compactMap { $0 as? NavigationItemViewControlling }
//    let viewControllerIds = viewControllers.map { $0.item.id }
//    let itemIds = items.map { $0.id }
//    let newItemViewControllers: [NavigationItemViewControlling] = items.map { item in
//      if let viewController = viewControllers.first(where: { $0.item.id == item.id }) {
//        viewController.item = item
//        return viewController
//      }
//      let view = NavigationItemView(item: item, items: $items)
//      return NavigationItemViewController(item, rootView: view)
//    }
//    guard viewControllerIds != itemIds else { return }
//    let animate = !viewControllers.isEmpty
//    print("^^^ updating view controllers (\(viewControllers.count) → \(newItemViewControllers.count)), animated: \(animate)")
//    navigationController.setViewControllers(newItemViewControllers, animated: animate)
//  }
//
//  func makeCoordinator() -> Coordinator {
//    Coordinator(items: $items)
//  }
//
//  class Coordinator: NSObject, UINavigationControllerDelegate {
//    init(items: Binding<[NavigationItem]>) {
//      self.items = items
//    }
//
//    let items: Binding<[NavigationItem]>
//
//    func navigationController(
//      _ navigationController: UINavigationController,
//      didShow viewController: UIViewController,
//      animated: Bool
//    ) {
//      let newItems = navigationController.viewControllers
//        .compactMap { $0 as? NavigationItemViewControlling }
//        .map { $0.item }
//      let newItemIds = newItems.map { $0.id }
//      let itemIds = items.wrappedValue.map { $0.id }
//      guard newItemIds != itemIds else { return }
//      print("^^^ updating items (\(items.wrappedValue.count) → \(newItems.count))")
//      items.wrappedValue = newItems
//    }
//  }
//}
//
//protocol NavigationItemViewControlling: UIViewController {
//  var item: NavigationItem { get set }
//}
//
//class NavigationItemViewController<Content: View>: UIHostingController<Content>, NavigationItemViewControlling {
//  init(_ item: NavigationItem, rootView: Content) {
//    self.item = item
//    super.init(rootView: rootView)
//    self.navigationItem.title = item.title
//  }
//
//  required init?(coder aDecoder: NSCoder) { nil }
//  var item: NavigationItem
//}
