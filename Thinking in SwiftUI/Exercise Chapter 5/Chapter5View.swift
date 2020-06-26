import SwiftUI

struct Chapter5View: View {
	let cells = [
		[Text(""), Text("Monday").bold(), Text("Tuesday").bold(), Text("Wednesday").bold()],
		[Text("Berlin").bold(), Text("Cloudy"), Text("Mostly\nSunny"), Text("Sunny")],
		[Text("London").bold(), Text("Heavy Rain"), Text("Cloudy"), Text("Sunny")],
	]

	var body: some View {
		Table(cells: cells).font(Font.system(.body, design: .serif))
	}
}

struct Chapter5View_Previews: PreviewProvider {
	static var previews: some View {
		return Chapter5View()
	}
}
