//
//  SearchView.swift
//  DogEar
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var theme: Theme
    var body: some View {
        NavigationStack {
            Text("Search goes here")
                .font(theme.body(16))
                .navigationTitle("Search")
        }
    }
}

#Preview {
    NavigationStack { HomeView() }
        .environmentObject(Theme())
}
