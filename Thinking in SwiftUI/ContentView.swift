//
//  ContentView.swift
//  Thinking in SwiftUI
//
//  Created by Xaver Lohmüller on 13.06.20.
//  Copyright © 2020 Xaver Lohmüller. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @State var counter = 0
  var body: some View {
    NavigationView {
      List {
        NavigationLink(destination: PhotosList()) {
          Text("Exercise Chapter 2")
        }
        NavigationLink(destination: KnobView()) {
          Text("Exercise Chapter 3")
        }
        NavigationLink(destination: Chapter4View()) {
          Text("Exercise Chapter 4")
        }
      }
      .navigationBarTitle("Thinking in SwiftUI")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
