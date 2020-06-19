import SwiftUI

struct KnobShape: Shape {
  var pointerSize: CGFloat = 0.1 // these are relative values
  var pointerWidth: CGFloat = 0.1
  func path(in rect: CGRect) -> Path {
    let pointerHeight = rect.height * pointerSize
    let pointerWidth = rect.width * self.pointerWidth
    let circleRect = rect.insetBy(dx: pointerHeight, dy: pointerHeight)
    return Path { p in
      p.addEllipse(in: circleRect)
      p.addRect(CGRect(x: rect.midX - pointerWidth/2, y: 0, width: pointerWidth, height: pointerHeight + 2))
    }
  }
}

struct ColorKey: EnvironmentKey {
  static let defaultValue: Color? = nil
}

extension EnvironmentValues {
  var knobColor: Color? {
    get { self[ColorKey.self] }
    set { self[ColorKey.self] = newValue }
  }
}

extension View {
  func knobColor(_ color: Color?) -> some View {
    environment(\.knobColor, color)
  }
}

struct Knob: View {
  @Binding var value: Double // should be between 0 and 1
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @Environment(\.knobColor) var knobColor: Color?

  var fillColor: Color {
    knobColor ?? (colorScheme == .dark ? .white : .black)
  }

  var body: some View {
    KnobShape()
      .fill(fillColor)
      .rotationEffect(Angle(degrees: value * 330))
      .onTapGesture {
        withAnimation(.default) {
          self.value = self.value < 0.5 ? 1 : 0
        }
    }
  }
}

struct KnobView: View {
  @State var value: Double = 0.5
  @State var knobSize: CGFloat = 0.1

  var body: some View {
    VStack {
      Knob(value: $value)
        .frame(width: 100, height: 100)
      HStack {
        Text("Value")
        Slider(value: $value, in: 0...1)
      }
      HStack {
        Text("Knob Size")
        Slider(value: $knobSize, in: 0...0.4)
      }
      Button(action: {
        withAnimation(.default) {
          self.value = self.value == 0 ? 1 : 0
        }
      }, label: { Text("Toggle")})
    }
  }
}

struct KnobView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      KnobView()
      KnobView()
        .colorScheme(.dark)
      KnobView()
        .knobColor(.blue)
      KnobView()
        .knobColor(.black)
      KnobView()
        .knobColor(.purple)
    }
      .previewLayout(.sizeThatFits)
  }
}
