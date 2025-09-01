//
//  SearchView.swift
//  DogEar
//
//  Created by Hannah Norman on 8/31/25.
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
