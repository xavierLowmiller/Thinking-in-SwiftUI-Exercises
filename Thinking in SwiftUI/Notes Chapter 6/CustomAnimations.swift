import SwiftUI

struct Shake: AnimatableModifier {
  var times: CGFloat = 0
  let amplitude: CGFloat = 10

  var animatableData: CGFloat {
    get { times }
    set { times = newValue }
  }

  func body(content: Content) -> some View {
    content.offset(x: sin(times * .pi * 2) * amplitude)
  }
}

extension View {
  func shake(times: Int) -> some View {
    modifier(Shake(times: CGFloat(times)))
  }
}

struct ShakingView: View {
  @State private var taps = 0

  var body: some View {
    Button("Tap Me") {
      withAnimation {
        taps += 1
      }
    }.shake(times: taps * 3)
  }
}
