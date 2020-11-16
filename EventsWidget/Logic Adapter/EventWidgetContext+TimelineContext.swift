import EventsWidgetLogic
import SwiftUI
import WidgetKit

extension EventWidgetContext {
    
    init(timelineContext: EventsTimelineProvider.Context) {
        let accessibilitySize: EventWidgetContext.AccessibilityCategory = {
            guard let contentSize = timelineContext.environmentVariants[\.sizeCategory]?.first else { return .standard }
            return contentSize > .extraLarge ? .large : .standard
        }()
        
        let widgetSizes: [WidgetFamily: EventWidgetContext.WidgetSize] = [
            .systemSmall: .small,
            .systemMedium: .medium,
            .systemLarge: .large
        ]
        
        let widgetSize = widgetSizes[timelineContext.family, default: .small]
        
        self.init(accessibilityCategory: accessibilitySize, widgetSize: widgetSize)
    }
    
}
