import SwiftUI

struct WidthKey: PreferenceKey {
  static let defaultValue: CGFloat? = nil

  static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
    value = value ?? nextValue()
  }
}

struct TextWithCircle: View {
  let text: String

  @State private var width: CGFloat? = nil

  var body: some View {
    Text(text)
    .padding()
      .background(GeometryReader { proxy in
        Color.clear.preference(key: WidthKey.self, value: proxy.size.width)
      })
      .onPreferenceChange(WidthKey.self) {
        self.width = $0
    }
    .frame(width: width, height: width)
    .background(Circle().fill(Color.blue))
    .border(Color.black)
  }
}

struct LayoutWithPreferenceKey_Previews: PreviewProvider {
  static var previews: some View {
    TextWithCircle(text: "Hello, world")
  }
}
