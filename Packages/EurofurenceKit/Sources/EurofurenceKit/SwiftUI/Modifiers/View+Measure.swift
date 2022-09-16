import SwiftUI

extension View {
    
    /// Installs a modifier that invokes the given closure whenever the size of the view changes.
    /// - Parameter onChange: A closure that will be invkoed when the size of the view is known. The size parameter
    ///                       represents the size of the view.
    /// - Returns: A modified `View` with auto-measurements enabled.
    public func measure(onChange: @escaping (CGSize) -> Void) -> some View {
        ModifiedContent(content: self, modifier: MeasuredViewModifier(onChange: onChange))
            .onPreferenceChange(SizePreferenceKey.self) { newValue in
                onChange(newValue)
            }
    }
    
}

// MARK: - Modifier

private struct MeasuredViewModifier: ViewModifier {
    
    let onChange: (CGSize) -> Void
    @State private var size: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color
                        .clear
                        .preference(key: SizePreferenceKey.self, value: proxy.size)
                }
            )
    }
    
}

// MARK: - Preference

private struct SizePreferenceKey: PreferenceKey {
    
    typealias Value = CGSize
    
    static let defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
    
}
