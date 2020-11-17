import SwiftUI
import WidgetKit

struct WidgetContent<Header, Content>: View where Header: View, Content: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var header: Header
    var content: Content
    
    init(@ViewBuilder header: () -> Header, @ViewBuilder content: () -> Content) {
        self.header = header()
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .foregroundColor(.white)
                .padding([.leading])
                .padding([.top, .bottom], 10)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .background(Color.widgetBackground)
            
            content
                .padding([.leading, .trailing])
                .padding([.top, .bottom], 10)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .background(Color(colorScheme == .dark ? .black : .white))
        }
    }
    
}

struct WidgetContent_Previews: PreviewProvider {
    
    static var previews: some View {
        WidgetContent {
            Text("Heading")
        } content: {
            Text("Content")
        }
        .previewContext(WidgetPreviewContext(family: .systemLarge))
        
        WidgetContent {
            Text("Heading")
        } content: {
            Text("Content")
        }
        .colorScheme(.dark)
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
    
}
