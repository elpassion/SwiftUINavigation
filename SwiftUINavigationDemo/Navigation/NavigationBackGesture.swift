import SwiftUI

struct NavigationBackGesture: ViewModifier {
  init(action: @escaping () -> Void) {
    self.action = action
  }

  var action: () -> Void
  @GestureState var dragOffset: CGFloat = 0

  func body(content: Content) -> some View {
    content
      .offset(x: dragOffset, y: 0)
      .gesture(gesture)
  }

  var gesture: some Gesture {
    DragGesture(minimumDistance: 8, coordinateSpace: .global)
      .updating($dragOffset, body: { value, state, _ in
        if self.shouldHandleGesture(for: value) {
          state = value.translation.width
        }
      })
      .onEnded({ value in
        if self.shouldTriggerAction(for: value) {
          self.action()
        }
      })
  }

  func shouldHandleGesture(for value: DragGesture.Value) -> Bool {
    value.startLocation.x <= 32
  }

  func shouldTriggerAction(for value: DragGesture.Value) -> Bool {
    guard shouldHandleGesture(for: value) else { return false }
    let offset = value.translation.width
    let velocity = value.location.x.distance(to: value.predictedEndLocation.x)
    return offset + velocity >= 128
  }
}

extension View {
  func navigationBackGesture(action: @escaping () -> Void) -> some View {
    modifier(NavigationBackGesture(action: action))
  }
}
