import SwiftUI

/// Provides a centralized set of colors used throughout the app.
enum ColorTheme {
    /// Dark background color matching Apple Watch style (#000000).
    static let backgroundBlack = Color.black
    /// Primary text color for readability (#FFFFFF).
    static let textWhite = Color.white
    /// Accent orange used for highlights (#FF9500).
    static let accentOrange = Color(red: 1, green: 149/255, blue: 0)
    /// Dark gray for button backgrounds (#1C1C1E).
    static let buttonDarkGray = Color(red: 28/255, green: 28/255, blue: 30/255)
}
