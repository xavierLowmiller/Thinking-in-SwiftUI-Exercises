import SwiftUI

struct LineGraph: Shape {
  let data: [CGFloat]

  func path(in rect: CGRect) -> Path {
    Path { p in
      guard data.count > 1 else { return }

      let (horizontalScale, verticalScale) = (rect.width, rect.height)
      let points = data.enumerated().map { offset, value in
        CGPoint(
          x: horizontalScale * CGFloat(offset) / CGFloat(data.count - 1),
          y: (1 - value) * verticalScale
        )
      }

      p.move(to: points[0])
      for point in points {
        p.addLine(to: point)
      }
    }
  }
}

struct PositionOnShapeEffect: GeometryEffect {
  let path: Path
  var amount: CGFloat

  var animatableData: CGFloat {
    get { amount }
    set { amount = newValue }
  }

  func effectValue(size: CGSize) -> ProjectionTransform {
    let endPoint = path
      .trimmedPath(from: 0, to: max(amount, 0.000001))
      .currentPoint ?? .zero
    let transform = CGAffineTransform(
      translationX: endPoint.x - size.width / 2,
      y: endPoint.y - size.height / 2)
    return ProjectionTransform(transform)
  }
}

extension View {
  func position<S: Shape>(on shape: S, at amount: CGFloat) -> some View {
    GeometryReader { proxy in
      self.modifier(
        PositionOnShapeEffect(
          path: shape.path(in: CGRect(origin: .zero, size: proxy.size)),
          amount: amount)
      )
    }
  }
}

struct LineGraphView: View {
  let sampleData: [CGFloat] = [0.1, 0.7, 0.3, 0.6, 0.45, 1.1]

  @State private var isVisible = false

  var body: some View {
    VStack {
      ZStack {
        LineGraph(data: sampleData)
          .trim(from: 0, to: isVisible ? 1 : 0)
          .stroke(Color.red, lineWidth: 2)
          .border(Color.gray, width: 1)

        Circle()
          .fill(Color.red)
          .frame(width: 10, height: 10)
          .position(on: LineGraph(data: sampleData), at: isVisible ? 1 : 0)
      }
      .aspectRatio(3/2, contentMode: .fit)
      .padding()


      Button("Animate") {
        withAnimation(.linear(duration: 1)) {
          isVisible.toggle()
        }
      }
    }
  }
}

struct PathAnimations_Previews: PreviewProvider {
  static var previews: some View {
    LineGraphView()
  }
}
