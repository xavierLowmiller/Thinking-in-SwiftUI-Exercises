import SwiftUI

struct Collapsible<Element: Hashable, Content: View>: View {
  var data: [Element]
  var collapsedOffset: CGFloat = 8
  var verticalAlignment: VerticalAlignment = .center
  var expanded: Bool = false
  var content: (Element) -> Content

  private func shouldCollapse(at index: Int) -> Bool {
    !expanded && index != data.count - 1
  }

  var body: some View {
    HStack(alignment: verticalAlignment, spacing: expanded ? nil : 0) {
      ForEach(Array(data.enumerated()), id: \.self.offset) { index, item in
        self.content(item)
          .frame(width: self.shouldCollapse(at: index) ? self.collapsedOffset : nil,
                 alignment: .leading)
      }
    }
      .animation(.default)
  }
}

struct Collapsible_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Collapsible(data: [100, 200], expanded: true, content: { width in
        Rectangle().frame(width: width, height: width)
      })
      Collapsible(data: [100, 200], expanded: false, content: { width in
        Rectangle().frame(width: width, height: width)
      })
    }.previewLayout(.sizeThatFits)
  }
}
