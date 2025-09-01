//
//  Theme.swift
//  DogEar
//
//  Created by Hannah Norman on 8/31/25.
//

import SwiftUI

final class Theme: ObservableObject {
    // Color tokens (must match Assets.xcassets names)
    @Published var background = Color("Background")
    @Published var surface    = Color("Surface")
    @Published var primary    = Color("TextPrimary")
    @Published var accent     = Color("Accent")
    @Published var textOnLight = Color("TextOnLight")

    // Fonts
    func title(_ size: CGFloat) -> Font {
        .custom("FatFrank-Heavy", size: size)
    }

    func body(_ size: CGFloat) -> Font {
        .custom("ProximaNova-Regular", size: size)
    }

    func meta(_ size: CGFloat, light: Bool = false) -> Font {
        .custom(light ? "Mono45Headline-Light" : "Mono45Headline-Regular", size: size)
    }
}

// Optional: card-style modifier for reusable surfaces
struct CardStyle: ViewModifier {
    @EnvironmentObject var theme: Theme
    func body(content: Content) -> some View {
        content
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(radius: 3, y: 2)
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardStyle()) }
}
