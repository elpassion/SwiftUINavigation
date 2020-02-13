import SwiftUI

class Store: ObservableObject {
  @Published var navigation: [NavigationItem] = [RootState()]
}
