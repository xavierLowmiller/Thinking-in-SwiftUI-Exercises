import SwiftUI

struct WidthPreference: PreferenceKey {
	static let defaultValue: [Int: CGFloat] = [:]
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value.merge(nextValue(), uniquingKeysWith: max)
	}
}

struct HeightPreference: PreferenceKey {
	static let defaultValue: [Int: CGFloat] = [:]
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value.merge(nextValue(), uniquingKeysWith: max)
	}
}

struct CollectMaxWidth: ViewModifier {
	var index: Int
	func body(content: Content) -> some View {
		content.background(GeometryReader { proxy in
			Color.clear.preference(
				key: WidthPreference.self,
				value: [index: proxy.size.width]
			)
		})
	}
}

struct CollectMaxHeight: ViewModifier {
	var index: Int
	func body(content: Content) -> some View {
		content.background(GeometryReader { proxy in
			Color.clear.preference(
				key: HeightPreference.self,
				value: [index: proxy.size.height]
			)
		})
	}
}

struct Table<Content: View>: View {
	let cells: [[Content]]
	@State private var widths: [Int: CGFloat] = [:]
	@State private var heights: [Int: CGFloat] = [:]
	@State private var selected: (row: Int, column: Int)?

	func isSelected(row: Int, column: Int) -> Bool {
		if let selected = selected {
			return row == selected.row && column == selected.column
		} else {
			return false
		}
	}

	var body: some View {
		VStack {
			ForEach(cells.indices) { row in
				HStack {
					ForEach(cells[row].indices) { column in
						cells[row][column]
							.padding(2)
							.modifier(CollectMaxWidth(index: column))
							.modifier(CollectMaxHeight(index: row))
							.frame(minWidth: widths[column], minHeight: heights[row], alignment: .leading)
							.border(isSelected(row: row, column: column) ? Color.blue : Color.clear, width: 2)
							.onTapGesture { withAnimation { selected = (row, column) } }
					}
				}.background(row.isMultiple(of: 2) ? Color.white : Color(.systemGroupedBackground))
			}
		}
		.onPreferenceChange(WidthPreference.self) { widths = $0 }
		.onPreferenceChange(HeightPreference.self) { heights = $0 }
	}
}

struct Chapter5View: View {
	let cells = [
		[Text(""), Text("Monday").bold(), Text("Tuesday").bold(), Text("Wednesday").bold()],
		[Text("Berlin").bold(), Text("Cloudy"), Text("Mostly\nSunny"), Text("Sunny")],
		[Text("London").bold(), Text("Heavy Rain"), Text("Cloudy"), Text("Sunny")],
	]

	var body: some View {
		Table(cells: cells)
			.font(Font.system(.body, design: .serif))
	}
}

struct TableView_Previews: PreviewProvider {
	static var previews: some View {
		return Chapter5View()
	}
}
