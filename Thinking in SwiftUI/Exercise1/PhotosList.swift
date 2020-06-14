import SwiftUI

struct PhotosList: View {
  @ObservedObject private var remote = Remote<[Photo]>(
    url: URL(string: "https://picsum.photos/v2/list")!
  )

  var body: some View {
    Group {
      if remote.value != nil {
        List {
          ForEach(remote.value!) { photo in
            NavigationLink(destination: PhotoDetailView(photo: photo)) {
              Text(photo.author)
            }
          }
        }
      } else if remote.errorMessage != nil {
        Text("Error loading the photos:\n\n\(remote.errorMessage!)")
          .multilineTextAlignment(.center)
      } else {
        Text("Loading...")
      }
    }
    .onAppear {
      self.remote.refresh()
    }
    .navigationBarTitle("Exercise 1")
  }
}

struct PhotosList_Previews: PreviewProvider {
  static var previews: some View {
    PhotosList()
  }
}
