import SwiftUI
import UIKit

struct ContentView: View {
  @ObservedObject var store = Store()

  var body: some View {
    NavigationStackView(
      items: $store.navigation,
      viewFactory: navigationItemViewFactory
    ).environmentObject(store)
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif

// MARK: - State

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

// MARK: - Views

struct RootView: View {
  init(state: RootState) {
    self.state = state
  }

  @EnvironmentObject var store: Store
  let state: RootState

  var body: some View {
    NavigationItemView(navigationBar: { EmptyView() }, content: {
      VStack(spacing: 16) {
        Text("Root").font(.title)
        Button(action: {
          self.store.navigation.append(StepState(step: 1))
        }) { Text("Go to first step →") }
      }
    })
  }
}

struct StepView: View {
  init(state: StepState) {
    self.state = state
  }

  @EnvironmentObject var store: Store
  let state: StepState

  var body: some View {
    NavigationItemView(navigationBar: {
      NavigationBarView(title: {
        Text("Step \(self.state.step)").font(.headline)
      }, leadingView: {
        NavigationBackButton {
          _ = self.store.navigation.removeLast()
        }
      }, trailingView: {
        EmptyView()
      })
    }) {
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
}

let navigationItemViewFactory = combine(
  optional(RootView.init(state:)),
  optional(StepView.init(state:))
)

// MARK: - Navigation

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

struct NavigationStackView: View {
  init(items: Binding<[NavigationItem]>, viewFactory: @escaping NavigationItemViewFactory) {
    self._items = items
    self.viewFactory = viewFactory
  }

  @Binding var items: [NavigationItem]
  var viewFactory: NavigationItemViewFactory

  var body: some View {
    ZStack {
      EmptyView()
      ForEach(Array(items.enumerated()), id: \.element.navigationId) { index, item in
        self.viewFactory(item)
          .animation(.easeInOut(duration: 0.25))
          .transition(.move(edge: .trailing))
          .zIndex(Double(index))
      }
    }
  }
}

struct NavigationItemView<NavigationBar: View, Content: View>: View {
  init(@ViewBuilder navigationBar: () -> NavigationBar,
                    @ViewBuilder content: () -> Content) {
    self.navigationBar = navigationBar()
    self.content = content()
  }

  var navigationBar: NavigationBar
  var content: Content

  var body: some View {
    ZStack(alignment: .top) {
      Color(UIColor.systemBackground)
        .edgesIgnoringSafeArea(.all)
      VStack(spacing: 0) {
        navigationBar
        ZStack {
          content
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}

struct NavigationBarView<Title: View, LeadingView: View, TrailingView: View>: View {
  init(@ViewBuilder title: () -> Title,
                    @ViewBuilder leadingView: () -> LeadingView,
                                 @ViewBuilder trailingView: () -> TrailingView) {
    self.title = title()
    self.leadingView = leadingView()
    self.trailingView = trailingView()
  }

  var title: Title
  var leadingView: LeadingView
  var trailingView: TrailingView

  var body: some View {
    ZStack {
      Color(UIColor.secondarySystemBackground)
        .edgesIgnoringSafeArea([.top, .leading, .trailing])
        .shadow(radius: 1)
      ZStack {
        title
        HStack(alignment: .firstTextBaseline, spacing: 16) {
          leadingView
          Spacer()
          trailingView
        }
      }.padding()
    }.fixedSize(horizontal: false, vertical: true)
  }
}

struct NavigationBackButton: View {
  init(action: @escaping () -> Void) {
    self.action = action
  }

  var action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack {
        Image(systemName: "chevron.left")
        Text("Back")
      }
    }
  }
}
