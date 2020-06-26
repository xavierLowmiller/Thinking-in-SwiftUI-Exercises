import SwiftUI

struct AnimatedButtonView: View {
	@State private var selected = false

	var body: some View {
		Button(action: { self.selected.toggle() }) {
			RoundedRectangle(cornerRadius: 10)
				.fill(selected ? Color.red : .green)
				.frame(width: selected ? 100 : 50,
							 height: selected ? 100 : 50)
		}.animation(.default)
	}
}

struct LoadingIndicator: View {
	@State private var isAnimating = false

	var body: some View {
		Image(systemName: "rays")
			.rotationEffect(isAnimating ? Angle.degrees(360) : .zero)
			.animation(Animation
									.linear(duration: 2)
									.repeatForever(autoreverses: false)
			)
			.onAppear { self.isAnimating = true }
	}
}

struct ImplicitAnimations_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			AnimatedButtonView()
			LoadingIndicator()
		}.previewLayout(.fixed(width: 300, height: 300))
	}
}
