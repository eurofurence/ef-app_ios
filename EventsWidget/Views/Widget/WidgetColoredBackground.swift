import SwiftUI

struct WidgetColoredBackground<Content>: View where Content: View {
    
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color.widgetBackground
            content
                .foregroundColor(.white)
        }
    }
    
}
