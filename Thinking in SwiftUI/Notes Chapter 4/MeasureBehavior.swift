import SwiftUI

struct MeasureBehavior<Content: View>: View {
  @State private var width: CGFloat = 100
  @State private var height: CGFloat = 100
  var content: Content
  var body: some View {
    VStack {
      content
        .border(Color.gray)
        .frame(width: width, height: height)
        .border(Color.black)
      VStack {
        HStack {
          Text("Width")
          Slider(value: $width, in: 0...500)
        }
        HStack {
          Text("Height")
          Slider(value: $height, in: 0...200)
        }
      }.padding()
    }
  }
}

struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    return Path { p in
      p.move(to: CGPoint(x: rect.midX, y: rect.minY))
      p.addLines([
        CGPoint(x: rect.maxX, y: rect.maxY),
        CGPoint(x: rect.minX, y: rect.maxY),
        CGPoint(x: rect.midX, y: rect.minY)
      ])
    }
  }
}

let path = Path { p in
  p.move(to: CGPoint(x: 50, y: 0))
  p.addLines([
    CGPoint(x: 100, y: 75),
    CGPoint(x: 0, y: 75),
    CGPoint(x: 50, y: 0)
  ])
}

let shape = Triangle()

let image = Image(systemName: "ellipsis")
let longText = Text("A Text view’s layout method always tries to fit its contents in the proposed size, and it returns the bounding box of the rendered text as its result. If the underlying string does not contain newlines, it attempts to render the entire text on a single line (given there is enough horizontal space). If there’s not enough horizontal space available, Text looks at the available vertical space. If there’s enough vertical space, it will break the text into multiple lines (line wrapping) and try to fit the entire text inside the proposed size. If there’s not enough vertical space either, the text will be truncated.")

struct MeasureBehavior_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MeasureBehavior(content: path)
      MeasureBehavior(content: shape)
      MeasureBehavior(content: HStack {
        image
        image.resizable()
        image.resizable().aspectRatio(contentMode: .fit)
      })
      MeasureBehavior(content: longText
//        .fixedSize()
//        .lineLimit(3)
//        .minimumScaleFactor(0.75)
//        .truncationMode(.head)
      )
      MeasureBehavior(content: HStack {
        Text("Hello, World")
        Rectangle().fill(Color.red).frame(minWidth: 200)
      })
      MeasureBehavior(content: HStack(spacing: 0) {
        Text("chapter1.md").truncationMode(.middle).lineLimit(1)
        Text("chapter1.md").layoutPriority(1)
      })
    }.previewLayout(.sizeThatFits)
  }
}
