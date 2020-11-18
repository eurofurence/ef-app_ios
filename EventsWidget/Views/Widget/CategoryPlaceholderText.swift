import EventsWidgetLogic
import SwiftUI

struct CategoryPlaceholderText: View {
    
    enum Size {
        
        case small
        case large
        
        @ViewBuilder
        fileprivate func applyModifiers<Text>(to text: Text) -> some View where Text: View {
            text
                .font(font.weight(.semibold))
        }
        
        private var font: Font {
            switch self {
            case .small:
                return .caption2
                
            case .large:
                return .headline
            }
        }
        
    }
    
    var category: EventCategory
    var size: Size
    
    var body: some View {
        size
            .applyModifiers(to: text)
            .foregroundColor(.white)
    }
    
    @ViewBuilder
    private var text: some View {
        switch category {
        case .upcoming:
            Text("No upcoming events")
            
        case .running:
            Text("No running events")
        }
    }
    
}
