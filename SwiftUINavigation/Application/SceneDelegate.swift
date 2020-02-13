import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    let store = Store()
    let view = AppView().environmentObject(store)
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = UIHostingController(rootView: view)
    self.window = window
    window.makeKeyAndVisible()
  }

}
