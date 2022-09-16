import SwiftUI

struct AlignedLabelContainer<Content>: View where Content: View {
    
    private let content: () -> Content
    @State private var preferredIconWidth: CGFloat = 0
    
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            content()
                .environment(\.preferredIconWidth, preferredIconWidth)
                .onPreferenceChange(IconWidthPreferenceKey.self) { newValue in
                    preferredIconWidth = newValue ?? 0
                }
                .labelStyle(EqualIconWidthLabelStyle())
        }
    }
    
}

private struct IconWidthPreferenceKey: PreferenceKey {
    
    typealias Value = CGFloat?
    
    static var defaultValue: CGFloat?
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        if let next = nextValue() {
            if let currentValue = value {
                value = max(currentValue, next)
            } else {
                value = next
            }
        }
    }
    
}

private extension EnvironmentValues {
    
    var preferredIconWidth: CGFloat {
        get {
            self[PreferredIconWidthEnvironmentKey.self]
        }
        set {
            self[PreferredIconWidthEnvironmentKey.self] = newValue
        }
    }
    
    struct PreferredIconWidthEnvironmentKey: EnvironmentKey {
        
        typealias Value = CGFloat
        
        static var defaultValue: CGFloat = 0
        
    }
    
}

private struct EqualIconWidthViewModifier: ViewModifier {
    
    @Environment(\.preferredIconWidth) private var preferredIconWidth
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color
                        .clear
                        .preference(key: IconWidthPreferenceKey.self, value: proxy.size.width)
                }
            )
            .frame(width: preferredIconWidth)
    }
    
}

private struct EqualIconWidthLabelStyle: LabelStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration
                .icon
                .modifier(EqualIconWidthViewModifier())
            
            configuration
                .title
        }
    }
    
}
