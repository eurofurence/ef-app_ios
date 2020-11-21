import EventsWidgetLogic
import SwiftUI
import WidgetKit

extension EventWidgetContext {
    
    init(timelineContext: EventsTimelineProvider.Context) {
        let contentSize = timelineContext.environmentVariants[\.sizeCategory]?.first ?? .accessibilityLarge
        let accessibilitySize = EventWidgetContext.AccessibilityCategory(sizeCategory: contentSize)
        
        let widgetSizes: [WidgetFamily: EventWidgetContext.WidgetSize] = [
            .systemSmall: .small,
            .systemMedium: .medium,
            .systemLarge: .large
        ]
        
        let widgetSize = widgetSizes[timelineContext.family, default: .small]
        
        self.init(accessibilityCategory: accessibilitySize, widgetSize: widgetSize)
    }
    
}

private extension EventWidgetContext.AccessibilityCategory {
    
    init(sizeCategory: ContentSizeCategory) {
        switch sizeCategory {
        case _ where sizeCategory <= .large:
            self = .large
        
        case .extraLarge:
            self = .extraLarge
            
        case .extraExtraLarge:
            self = .extraExtraLarge
            
        case _ where sizeCategory >= .extraExtraExtraLarge:
            self = .extraExtraExtraLarge
            
        default:
            self = .large
        }
    }
    
}
