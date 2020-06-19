import SwiftUI

struct Chapter4View: View {

  var body: some View {
    List {
      NavigationLink(destination: CollapsibleExerciseView()) {
        Text("Collapsible HStack")
      }
      NavigationLink(destination: BadgeExerciseView()) {
        Text("Badge View")
      }
    }.navigationBarTitle("Chapter 4")
  }
}

struct CollapsibleExerciseView: View {
  @State private var isExpanded = false
  var body: some View {
    VStack {
      Collapsible(data: [75, 50, 100], expanded: isExpanded) { width in
        Rectangle()
          .frame(width: width, height: width)
          .foregroundColor(Color(white: 1 - Double(width / 200)))
      }
      //      .border(Color.black)
      Button(isExpanded ? "Collapse" : "Expand") {
        self.isExpanded.toggle()
      }
    }
  }
}

struct BadgeExerciseView: View {
  @State private var count: UInt = 1

  var body: some View {
    VStack {
      Text("Hello")
        .padding(10)
        .background(Color.gray)
        .cornerRadius(5)
        .badge(count: count)
      HStack {
        Button("+") { self.count += 1 }
        Button("-") {
          guard self.count > 0 else { return }
          self.count -= 1
        }
      }.font(.largeTitle)
    }
  }
}

struct Chapter4View_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        Chapter4View()
      }
      CollapsibleExerciseView()
      BadgeExerciseView()
    }
  }
}
