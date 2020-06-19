import SwiftUI

struct Chapter4View: View {

  var body: some View {
    List {
      NavigationLink(destination: CollapsibleExerciseView()) {
        Text("Collapsible HStack")
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


struct Chapter4View_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        Chapter4View()
      }
      CollapsibleExerciseView()
    }
  }
}
