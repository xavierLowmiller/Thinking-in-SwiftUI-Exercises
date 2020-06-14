import SwiftUI

struct PhotoDetailView: View {
  let photo: Photo
  @ObservedObject private var remote: Remote<UIImage>
  
  init(photo: Photo) {
    self.photo = photo
    remote = Remote(url: photo.downloadUrl)
  }
  
  var body: some View {
    Group {
      if remote.value != nil {
        Image(uiImage: remote.value!)
          .resizable()
          .aspectRatio(.init(width: photo.width, height: photo.height), contentMode: .fit)
        Spacer()
      } else {
        Text("Loading Photo...")
      }
    }
    .navigationBarTitle(photo.author)
    .onAppear {
      self.remote.refresh()
    }
  }
}
