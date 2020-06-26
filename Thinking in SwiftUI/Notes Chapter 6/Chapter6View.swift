import SwiftUI

struct Chapter6View: View {
	var body: some View {
		List {
			NavigationLink(destination: AnimatedButtonView()) {
				Text("Animated Button View")
			}
      NavigationLink(destination: LoadingIndicator()) {
        Text("Loading Indicator")
      }
      NavigationLink(destination: TransitionAnimationView()) {
        Text("Transition Animation")
      }
      NavigationLink(destination: LoadingIndicatorImplicit()) {
        Text("Loading Indicator (Implicit)")
      }
      NavigationLink(destination: LoadingIndicatorExplicit()) {
        Text("Loading Indicator (Explicit)")
      }
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
