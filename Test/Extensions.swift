//
//  Color+Extensions.swift
//  Test
//
//  Created by Denis Litvin on 7/12/23.
//

import SwiftUI

extension Color {
    static func blend(_ start: Color, _ end: Color, progress: Double) -> Color {
        let red = start.components.red + (end.components.red - start.components.red) * progress
        let green = start.components.green + (end.components.green - start.components.green) * progress
        let blue = start.components.blue + (end.components.blue - start.components.blue) * progress
        let opacity = start.components.opacity + (end.components.opacity - start.components.opacity) * progress
        return Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension Color {
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        let color = NSColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var opacity: CGFloat = 0
        color.usingColorSpace(.sRGB)?.getRed(&red, green: &green, blue: &blue, alpha: &opacity)
        return (Double(red), Double(green), Double(blue), Double(opacity))
    }
}

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
             .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
