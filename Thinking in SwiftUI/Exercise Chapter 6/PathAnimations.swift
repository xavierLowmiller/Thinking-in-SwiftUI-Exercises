import SwiftUI

struct LineGraph: Shape {
  let data: [CGFloat]

  func path(in rect: CGRect) -> Path {
    guard data.count > 1 else { return Path() }

    let (horizontalScale, verticalScale) = (rect.width, rect.height)

    let points = data.enumerated().map { offset, value in
      CGPoint(
        x: horizontalScale * CGFloat(offset) / CGFloat(data.count - 1),
        y: (1 - value) * verticalScale
      )
    }

    var p = Path()
    p.move(to: points[0])

    return points.dropFirst().reduce(into: p) { path, point in
      path.addLine(to: point)
    }
  }
}

struct LineGraphView: View {
  let sampleData: [CGFloat] = [0.1, 0.7, 0.3, 0.6, 0.45, 1.1]

  var body: some View {
    LineGraph(data: sampleData)
      .stroke(Color.red, lineWidth: 2)
      .border(Color.gray, width: 1)
  }
}

struct PathAnimations_Previews: PreviewProvider {
  static var previews: some View {
    LineGraphView()
      .frame(width: 300, height: 150)
  }
}
