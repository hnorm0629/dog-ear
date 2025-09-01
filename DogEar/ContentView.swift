//
//  ContentView.swift
//  DogEar
//
//  Created by Hannah Norman on 8/31/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        /*
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
         */
        
        VStack(spacing: 20) {
            Text("D o g   E a r")
                .font(.custom("FatFrank-Heavy", size: 32))

            Text("Author · Year · Pages")
                .font(.custom("Mono45Headline-Regular", size: 18))

            Text("This is body text in Proxima Nova Regular.")
                .font(.custom("ProximaNova-Regular", size: 16))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
