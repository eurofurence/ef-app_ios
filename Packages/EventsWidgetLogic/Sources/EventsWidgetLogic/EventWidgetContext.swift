public struct EventWidgetContext {
    
    public enum AccessibilityCategory {
        
        case standard
        case large
        
    }
    
    public enum WidgetSize {
        
        case small
        case medium
        case large
        
        func numberOfWidgets(in accessibilityCategory: AccessibilityCategory) -> Int {
            switch self {
            case .small:
                return accessibilityCategory == .standard ? 2 : 1
                
            case .medium:
                return accessibilityCategory == .standard ? 3 : 2
                
            default:
                return accessibilityCategory == .standard ? 5 : 3
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
