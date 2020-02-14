import SwiftUI

struct NavigationBackGesture: ViewModifier {
  init(action: @escaping () -> Void) {
    self.action = action
  }

  var action: () -> Void
  @GestureState var dragOffset: CGFloat = 0
  @Environment(\.layoutDirection) var layoutDirection

  func body(content: Content) -> some View {
    GeometryReader { geometry in
      content
        .offset(x: self.dragOffset, y: 0)
        .gesture(DragGesture(minimumDistance: 8, coordinateSpace: .global)
          .updating(self.$dragOffset, body: { value, state, _ in
            if self.shouldHandleGesture(for: value, geometry, self.layoutDirection) {
              switch self.layoutDirection {
              case .leftToRight:
                state = value.translation.width
              case .rightToLeft:
                state = -value.translation.width
              @unknown default:
                fatalError()
              }
            }
          })
          .onEnded({ value in
            if self.shouldTriggerAction(for: value, geometry, self.layoutDirection) {
              self.action()
            }
          }))
    }
  }

  func shouldHandleGesture(
    for value: DragGesture.Value,
    _ geometry: GeometryProxy,
    _ layoutDirection: LayoutDirection
  ) -> Bool {
    switch layoutDirection {
    case .leftToRight:
      return value.startLocation.x <= 32
    case .rightToLeft:
      return value.startLocation.x >= geometry.frame(in: .global).maxX - 32
    @unknown default:
      fatalError()
    }
  }

  func shouldTriggerAction(
    for value: DragGesture.Value,
    _ geometry: GeometryProxy,
    _ layoutDirection: LayoutDirection
  ) -> Bool {
    guard shouldHandleGesture(for: value, geometry, layoutDirection) else {
      return false
    }
    let offset = value.translation.width
    let velocity = value.location.x.distance(to: value.predictedEndLocation.x)
    switch layoutDirection {
    case .leftToRight:
      return offset + velocity >= 128
    case .rightToLeft:
      return offset + velocity <= -128
    @unknown default:
      fatalError()
    }
  }
}

extension View {
  func navigationBackGesture(action: @escaping () -> Void) -> some View {
    modifier(NavigationBackGesture(action: action))
  }
}
