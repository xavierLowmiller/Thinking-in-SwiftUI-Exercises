import Foundation

struct World {
  var urlSession: URLSession = .shared
}

#if DEBUG
var Current = World()
#else
let Current = World()
#endif
