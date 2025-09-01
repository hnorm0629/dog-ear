//
//  DogEarApp.swift
//  DogEar
//
//  Created by Hannah Norman on 8/31/25.
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
