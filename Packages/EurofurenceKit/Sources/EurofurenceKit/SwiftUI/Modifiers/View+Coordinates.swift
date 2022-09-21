import SwiftUI

extension View {
    
    /// Installs a modifier that invokes the given closure whenever the coordinates of the view change.
    /// - Parameters:
    ///   - coordinateSpace: The coordinate space to resolve the coordinates of the view within.
    ///   - onChange: A closure that will be invkoed when the coordinates of the view is known. The frame parameter
    ///               represents the frame of the view in the designated coordinate space.
    /// - Returns: A modified `View` with auto-measurements enabled.
    public func coordinates(in coordinateSpace: CoordinateSpace, onChange: @escaping (CGRect) -> Void) -> some View {
        ModifiedContent(
            content: self,
            modifier: EstablishViewCoordinatesModifier(coordinateSpace: coordinateSpace, onChange: onChange)
        )
        .onPreferenceChange(CoordinatesPreferenceKey.self) { newValue in
            onChange(newValue)
        }
    }
    
}

// MARK: - Modifier

private struct EstablishViewCoordinatesModifier: ViewModifier {
    
    let coordinateSpace: CoordinateSpace
    let onChange: (CGRect) -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color
                        .clear
                        .preference(key: CoordinatesPreferenceKey.self, value: proxy.frame(in: coordinateSpace))
                }
            )
    }
    
}

// MARK: - Preference

private struct CoordinatesPreferenceKey: PreferenceKey {
    
    typealias Value = CGRect
    
    static let defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
    
}
