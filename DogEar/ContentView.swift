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
            Text("Background").padding().background(Color("Background"))
            Text("Surface").padding().background(Color("Surface"))
            Text("TextPrimary").foregroundColor(Color("TextPrimary"))
            Text("Accent").foregroundColor(Color("Accent"))
            Text("TextOnLight")
                .padding()
                .background(Color("TextPrimary"))
                .foregroundColor(Color("TextOnLight"))
        }
    }
}

#Preview {
    ContentView()
}
