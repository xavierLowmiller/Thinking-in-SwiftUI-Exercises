import Combine
import Foundation

struct World {
  var urlSession: URLSession = .shared
  var mainQueue: DispatchQueue = .main
}

#if DEBUG
var Current = World()
#else
let Current = World()
#endif
