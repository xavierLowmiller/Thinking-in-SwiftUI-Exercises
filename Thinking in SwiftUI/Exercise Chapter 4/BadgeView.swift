import SwiftUI

extension View {
  func badge(count: Int) -> some View {
    let width: CGFloat = count == 0 ? 0 : 12 + 12 * CGFloat(count.numberOfDigits)
    let height: CGFloat = count == 0 ? 0 : 24

    return overlay(
      ZStack {
          Capsule()
            .fill(Color.red)
            .animation(.default)
        if count != 0 {
          Text("\(count)")
            .foregroundColor(.white)
        }
      }
      .offset(x: width / 2, y: -height / 2)
      .frame(width: width, height: height)
      , alignment: .topTrailing)
  }
}

private extension Int {
  var numberOfDigits: Int {
    var number = self < 0 ? -self : self
    var numberOfDigits = 0
    while number != 0 {
      number /= 10
      numberOfDigits += 1
    }
    return numberOfDigits
  }
}

struct BadgeView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Text("Hello")
        .padding(10)
        .background(Color.gray)
        .cornerRadius(5)
        .badge(count: 0)
        .padding(30)
    }
    .previewLayout(.sizeThatFits)
  }
}
