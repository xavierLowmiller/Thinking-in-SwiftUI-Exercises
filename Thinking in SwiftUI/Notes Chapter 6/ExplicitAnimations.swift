import SwiftUI

struct LoadingIndicatorImplicit: View {
  @State private var appeared = false
  private let animation = Animation
    .linear(duration: 1.5)
    .repeatForever(autoreverses: false)
  
  var body: some View {
    Circle()
      .fill(Color.accentColor)
      .frame(width: 5, height: 5)
      .offset(y: -20)
      .rotationEffect(appeared ? .degrees(360) : .zero)
      .animation(animation) // This enables implicit animations
      .onAppear { appeared = true }
  }
}

struct LoadingIndicatorExplicit: View {
  @State private var appeared = false
  private let animation = Animation
    .linear(duration: 1.5)
    .repeatForever(autoreverses: false)
  
  var body: some View {
    Circle()
      .fill(Color.accentColor)
      .frame(width: 5, height: 5)
      .offset(y: -20)
      .rotationEffect(appeared ? .degrees(360) : .zero)
      .onAppear { withAnimation(animation) { appeared = true } }
    // This runs it explicitly  ^^^^^^^^^
  }
}
