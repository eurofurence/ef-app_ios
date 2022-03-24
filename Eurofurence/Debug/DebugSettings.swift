import Foundation

struct DebugSettings {
    
    private static let useWidgetBasedNewsFeedKey = "EFUseWidgetBasedNewsFeed"
    
    static var isWidgetBasedNewsFeedEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: useWidgetBasedNewsFeedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: useWidgetBasedNewsFeedKey)
        }
    }
    
}
