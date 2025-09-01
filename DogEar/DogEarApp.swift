//
//  DogEarApp.swift
//  DogEar
//

import SwiftUI

@main
struct DogEarApp: App {
    @StateObject private var theme = Theme()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(theme)
        }
    }
}
