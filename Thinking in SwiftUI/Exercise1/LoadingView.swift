import SwiftUI

struct LoadingView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIActivityIndicatorView {
    UIActivityIndicatorView(style: .large)
  }

  func updateUIView(_ view: UIActivityIndicatorView, context: Context) {
    view.startAnimating()
  }
}
