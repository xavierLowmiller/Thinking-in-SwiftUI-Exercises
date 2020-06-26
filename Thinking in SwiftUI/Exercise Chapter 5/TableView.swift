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

private struct Rect {
	let origin: (x: CGFloat, y: CGFloat)
	let size: (width: CGFloat?, height: CGFloat?)
	static let empty = Rect(origin: (0, 0), size: (nil, nil))
}

struct Table<Content: View>: View {
	let cells: [[Content]]
	let xSpacing: CGFloat = 8
	let ySpacing: CGFloat = 0
	@State private var widths: [Int: CGFloat] = [:]
	@State private var heights: [Int: CGFloat] = [:]
	@State private var selected: (row: Int, column: Int)? // = (2, 1)

	private var frameForSelectedCell: Rect {
		guard let selected = selected else { return .empty }

		return Rect(
			origin: (
				(0..<selected.column).map { (widths[$0] ?? 0) + xSpacing }.reduce(0, +),
				(0..<selected.row).map { (heights[$0] ?? 0) + ySpacing }.reduce(0, +)
			), size: (
				widths[selected.column],
				heights[selected.row]
			)
		)
	}

	var body: some View {
		VStack(spacing: ySpacing) {
			ForEach(cells.indices) { row in
				HStack(spacing: xSpacing) {
					ForEach(cells[row].indices) { column in
						cells[row][column]
							.padding(2)
							.modifier(CollectMaxWidth(index: column))
							.modifier(CollectMaxHeight(index: row))
							.frame(minWidth: widths[column], minHeight: heights[row], alignment: .leading)
							.onTapGesture { withAnimation { selected = (row, column) } }
					}
				}.background(row.isMultiple(of: 2) ? .white : Color(.systemGroupedBackground))
			}
		}
		.onPreferenceChange(WidthPreference.self) { widths = $0 }
		.onPreferenceChange(HeightPreference.self) { heights = $0 }
		.overlay(ZStack(alignment: .topLeading) {
			Color.clear
			Color.clear
				.border(selected == nil ? Color.clear : .blue, width: 2)
				.offset(x: frameForSelectedCell.origin.x,
								y: frameForSelectedCell.origin.y)
				.frame(width: frameForSelectedCell.size.width,
							 height: frameForSelectedCell.size.height)
		})
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
