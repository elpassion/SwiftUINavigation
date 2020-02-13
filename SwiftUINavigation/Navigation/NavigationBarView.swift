import SwiftUI

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
        HStack(alignment: .firstTextBaseline) {
          leadingView
          Spacer().padding(.horizontal)
          trailingView
        }
      }.padding()
    }.fixedSize(horizontal: false, vertical: true)
  }
}
