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
