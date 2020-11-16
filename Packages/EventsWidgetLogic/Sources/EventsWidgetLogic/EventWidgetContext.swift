public struct EventWidgetContext {
    
    public enum AccessibilityCategory {
        case standard
        case large
    }
    
    public enum WidgetSize {
        case small
        case medium
        case large
    }
    
    let accessibilityCategory: AccessibilityCategory
    let widgetSize: WidgetSize
    
    public init(accessibilityCategory: AccessibilityCategory, widgetSize: WidgetSize) {
        self.accessibilityCategory = accessibilityCategory
        self.widgetSize = widgetSize
    }
    
    public var recommendedNumberOfEvents: Int {
        accessibilityCategory == .standard ? 5 : 3
    }
    
}
