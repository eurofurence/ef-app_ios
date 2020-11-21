public struct EventWidgetContext {
    
    public enum AccessibilityCategory: Comparable {
        
        case large
        case extraLarge
        case extraExtraLarge
        case extraExtraExtraLarge
        
    }
    
    public enum WidgetSize {
        
        case small
        case medium
        case large
        
        func numberOfWidgets(in accessibilityCategory: AccessibilityCategory) -> Int {
            switch self {
            case .small:
                return accessibilityCategory <= .extraLarge ? 2 : 1
                
            case .medium:
                switch accessibilityCategory {
                case .large:
                    return 3
                    
                case .extraExtraExtraLarge:
                    return 1
                    
                default:
                    return 2
                }
                
            case .large:
                switch accessibilityCategory {
                case .large:
                    return 6
                    
                case .extraLarge:
                    fallthrough
                case .extraExtraLarge:
                    return 5
                    
                case .extraExtraExtraLarge:
                    return 4
                }
            }
        }
        
    }
    
    let accessibilityCategory: AccessibilityCategory
    let widgetSize: WidgetSize
    
    public init(accessibilityCategory: AccessibilityCategory, widgetSize: WidgetSize) {
        self.accessibilityCategory = accessibilityCategory
        self.widgetSize = widgetSize
    }
    
    public var recommendedNumberOfEvents: Int {
        widgetSize.numberOfWidgets(in: accessibilityCategory)
    }
    
}
