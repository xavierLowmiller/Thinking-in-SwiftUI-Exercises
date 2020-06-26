import SwiftUI

struct TransitionAnimationView: View {
  @State private var visible = false

  var body: some View {
    VStack {
      Button("Toggle") { visible.toggle() }
      if visible {
        Rectangle()
          .fill(Color.blue)
          .frame(width: 100, height: 100)
//          .transition(.slide)
          .transition(.blur)
//          .transition(AnyTransition.asymmetric(
//                        insertion: .slide,
//                        removal: .blur))
//          .transition(AnyTransition
//                        .move(edge: .leading)
//                        .combined(with: .opacity))
          .animation(.default)
      } else {
        Color.clear
          .frame(width: 100, height: 100)
      }
    }
  }
}

struct Blur: ViewModifier {
  var active: Bool

  func body(content: Content) -> some View {
    content
      .blur(radius: active ? 50 : 0)
      .opacity(active ? 0 : 1)
  }
}

extension AnyTransition {
  static var blur: AnyTransition {
    .modifier(active: Blur(active: true),
              identity: Blur(active: false))
  }
}
