public struct EventWidgetContext {
    
    public enum AccessibilityCategory {
        
        case standard
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
                return accessibilityCategory == .large ? 2 : 1
                
            case .medium:
                return accessibilityCategory == .large ? 3 : 2
                
            default:
                return accessibilityCategory == .large ? 5 : 3
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
