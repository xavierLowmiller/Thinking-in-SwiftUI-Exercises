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
