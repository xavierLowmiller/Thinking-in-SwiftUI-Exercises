import SwiftUI

struct ContentView: View {
  @State var counter = 0
  var body: some View {
    NavigationView {
      List {
        NavigationLink(destination: PhotosList()) {
          Text("Chapter 2")
        }
        NavigationLink(destination: KnobView()) {
          Text("Chapter 3")
        }
        NavigationLink(destination: Chapter4View()) {
          Text("Chapter 4")
        }
				NavigationLink(destination: Chapter5View()) {
					Text("Chapter 5")
				}
				NavigationLink(destination: Chapter6View()) {
					Text("Chapter 6")
				}
      }
      .navigationBarTitle("Thinking in SwiftUI")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
