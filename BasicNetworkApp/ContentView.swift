//
//  ContentView.swift
//  BasicNetworkApp
//
//  Created by Thor on 10/11/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                NetworkController.foo()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
