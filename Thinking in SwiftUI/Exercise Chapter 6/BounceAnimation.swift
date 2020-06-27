import SwiftUI

struct Bounce: AnimatableModifier {
  var times: CGFloat = 0
  var amplitude: CGFloat = 30
  
  var animatableData: CGFloat {
    get { times }
    set { times = newValue }
  }

  func body(content: Content) -> some View {
    content.offset(y: -abs(sin(times * .pi * 3)) * amplitude * 1.3 * exp(2 * (floor(times) - times)))
  }
}

extension View {
  func bounce(times: Int, amplitude: CGFloat) -> some View {
    modifier(Bounce(times: CGFloat(times), amplitude: amplitude))
  }
}

extension AnyTransition {
  static var bounce: AnyTransition {
    .modifier(active: Bounce(times: 0, amplitude: 30),
              identity: Bounce(times: 1, amplitude: 30))
  }
}

struct BouncingView: View {
  @State private var taps = 0
  @State private var amplitude: CGFloat = 30
  @State private var showRect = false

  var body: some View {
    VStack {
      VStack {
        Text("Amplitude: \(amplitude)")
        Slider(value: $amplitude, in: 0...100)
      }
      Button("Tap Me") {
        withAnimation(.linear(duration: 1)) {
          taps += 1
        }
      }.bounce(times: taps, amplitude: amplitude)
      Divider()
      Button("Trigger bouncy transition") {
        showRect.toggle()
      }
      if showRect {
        Color.purple
          .frame(width: 100, height: 100)
          .transition(.bounce)
      } else {
        Color.clear
          .frame(width: 100, height: 100)
      }
    }
  }
}
