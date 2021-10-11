import SwiftUI

extension View {
    
    func springboardStyle() -> some View {
        ModifiedContent(content: self, modifier: EurofurenceSpringboardWidgetModifier())
    }
    
}

struct EurofurenceSpringboardWidgetModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .padding([.leading, .bottom])
            .background(
                LinearGradient(colors: [
                    .widgetContentBackgroundGradientStart,
                    .widgetContentBackgroundGradientEnd
                ], startPoint: .top, endPoint: .bottom)
            )
    }
    
}
