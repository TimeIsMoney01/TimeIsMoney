import SwiftUI

/// Provides a centralized set of colors used throughout the app.
enum ColorTheme {
    /// Dark background color matching Apple Watch style (#000000).
    static let backgroundBlack = Color.black
    /// Primary text color for readability (#FFFFFF).
    static let textWhite = Color.white
    /// Accent orange used for highlights (#FF9500).
    static let accentOrange = Color(red: 1, green: 149/255, blue: 0)
    /// Dark gray for button backgrounds (#3C3C3E).
    static let buttonDarkGray = Color(red: 60/255, green: 60/255, blue: 62/255)
}
