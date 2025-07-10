import SwiftUI

/// Provides a centralized set of fonts used throughout the app.
struct FontTheme {
    /// Bold title font for large headings.
    static let titleFont = Font.system(size: 28, weight: .bold, design: .default)
    /// Semibold font for subtitles and section headers.
    static let subtitleFont = Font.system(size: 20, weight: .semibold, design: .default)
    /// Semibold font sized for buttons.
    static let buttonFont = Font.system(size: 18, weight: .semibold, design: .default)
    /// Standard body text font.
    static let bodyFont = Font.system(size: 16, weight: .regular, design: .default)
}
