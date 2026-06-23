//
//  MarkdownTextSelectionModifier.swift
//  MarkdownView
//
//  Adds opt-in selection (and copy) support for rendered Markdown text.
//

import SwiftUI

// MARK: - SwiftUI Environment

struct MarkdownTextSelectionEnabledKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var markdownTextSelectionEnabled: Bool {
        get { self[MarkdownTextSelectionEnabledKey.self] }
        set { self[MarkdownTextSelectionEnabledKey.self] = newValue }
    }
}

// MARK: - Public Modifier

extension View {
    /// Allows the user to select — and copy — the rendered Markdown text.
    ///
    /// Text-bearing blocks (paragraphs, headings, list items, block quotes and
    /// code blocks) become selectable. Interactive or custom block views — such
    /// as images or custom block-directive renderers — remain interactive and
    /// are unaffected.
    ///
    /// Because Markdown documents interleave selectable text with interactive
    /// views, selection is scoped per text block rather than across the whole
    /// document.
    ///
    /// Selection is **disabled by default** to preserve existing tap and gesture
    /// behavior. Enable it explicitly:
    ///
    /// ```swift
    /// MarkdownView(text)
    ///     .markdownTextSelection()
    /// ```
    ///
    /// - Parameter enabled: Whether the rendered Markdown text is selectable.
    nonisolated public func markdownTextSelection(_ enabled: Bool = true) -> some View {
        environment(\.markdownTextSelectionEnabled, enabled)
    }
}

// MARK: - Internal Helper

extension View {
    /// Applies SwiftUI's text selection on platforms that support it.
    ///
    /// `textSelection(_:)` is unavailable on watchOS and tvOS, so it is gated
    /// behind the supported platforms to keep the package building everywhere.
    @ViewBuilder
    func markdownTextSelectionEnabledIfPossible(_ enabled: Bool) -> some View {
        #if os(iOS) || os(macOS) || os(visionOS)
        if enabled {
            textSelection(.enabled)
        } else {
            self
        }
        #else
        self
        #endif
    }
}
