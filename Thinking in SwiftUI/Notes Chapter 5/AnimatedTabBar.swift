import SwiftUI

struct BoundsKey: PreferenceKey {
  static let defaultValue: Anchor<CGRect>? = nil
  static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
    value = value ?? nextValue()
  }
}

struct TabBarView: View {
  let tabs: [Text] = [
    Text("World Clock"),
    Text("Alarm"),
    Text("Bedtime")
  ]
  @State private var selectedTabIndex = 0

  var body: some View {
    HStack {
      ForEach(tabs.indices) { tabIndex in
        Button(action: {
          self.selectedTabIndex = tabIndex
        }, label: { self.tabs[tabIndex] })
          .anchorPreference(key: BoundsKey.self, value: .bounds, transform: {
            anchor in
            self.selectedTabIndex == tabIndex ? anchor : nil
          })
      }
    }.overlayPreferenceValue(BoundsKey.self, { anchor in
      GeometryReader { proxy in
        Rectangle()
          .fill(Color.blue)
          .frame(width: proxy[anchor!].width, height: 2)
          .offset(x: proxy[anchor!].minX)
          .frame(
            width: proxy.size.width,
            height: proxy.size.height,
            alignment: .bottomLeading
        )
          .animation(.default)
//        Rectangle()
//          .fill(Color.accentColor)
//          .frame(width: proxy[anchor!].width, height: 2)
//          .offset(x: proxy[anchor!].minX)
      }
    })
  }
}

struct AnimatedTabBar_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView()
  }
}
