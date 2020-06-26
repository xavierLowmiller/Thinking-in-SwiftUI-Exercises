import SwiftUI

struct AnimatedButtonView: View {
	@State private var selected = false

	var body: some View {
		Button(action: { self.selected.toggle() }) {
			RoundedRectangle(cornerRadius: 10)
				.fill(selected ? Color.red : .green)
				.frame(width: selected ? 100 : 50,
							 height: selected ? 100 : 50)
        .rotationEffect(.degrees(selected ? 45 : 0))
    }.animation(.default)
	}
}

struct LoadingIndicator: View {
	@State private var isAnimating = false

	var body: some View {
		Image(systemName: "rays")
			.rotationEffect(isAnimating ? Angle.degrees(360) : .zero)
			.animation(Animation
                  .linear(duration: 1.5)
									.repeatForever(autoreverses: false)
			)
			.onAppear { self.isAnimating = true }
	}
}

struct TransitionAnimationView: View {
  @State private var visible = false

  var body: some View {
    VStack {
      Button("Toggle") { visible.toggle() }
      if visible {
        Rectangle()
          .fill(Color.blue)
          .frame(width: 100, height: 100)
          .transition(.slide)
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

struct ImplicitAnimations_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			AnimatedButtonView()
			LoadingIndicator()
      TransitionAnimationView()
		}.previewLayout(.fixed(width: 300, height: 300))
	}
}
