import SwiftUI

struct Chapter6View: View {
	var body: some View {
		List {
			NavigationLink("Animated Button View",
                     destination: AnimatedButtonView())
      NavigationLink("Loading Indicator",
                     destination: LoadingIndicator())
      NavigationLink("Transition Animation",
                     destination: TransitionAnimationView())
      NavigationLink("Loading Indicator (Implicit)",
                     destination: LoadingIndicatorImplicit())
      NavigationLink("Loading Indicator (Explicit)",
                     destination: LoadingIndicatorExplicit())
      NavigationLink("Custom Animation",
                     destination: ShakingView())
		}
	}
}

struct Chapter6View_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			Chapter6View()
		}
	}
}
