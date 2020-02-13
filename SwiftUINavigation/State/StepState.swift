import Foundation

struct StepState: NavigationItem {
  let navigationId = UUID()
  let step: Int
  var counter: Int = 0
}
