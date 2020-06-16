import SwiftUI

struct PhotoDetailView: View {
  let photo: Photo
  @ObservedObject private var remote: Remote<UIImage>
  
  init(photo: Photo) {
    self.photo = photo
    remote = Remote(url: photo.downloadUrl)
  }
  
  var body: some View {
    VStack {
      Group {
        if remote.value != nil {
          Image(uiImage: remote.value!)
            .resizable()
        } else {
          LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .onAppear(perform: self.remote.load)
        }
      }
      .background(Color(.secondarySystemBackground))
      .aspectRatio(.init(width: photo.width, height: photo.height), contentMode: .fit)
      .cornerRadius(4)
      .padding()
      Spacer()
    }
    .navigationBarTitle(photo.author)
  }
}
