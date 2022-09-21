#if canImport(AppKit)
import AppKit
#endif
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

#if os(iOS)
typealias WindowType = UIWindow
#elseif os(macOS)
typealias WindowType = NSWindow
#endif

extension EnvironmentValues {
    
    var window: WindowType {
        get {
            self[WindowEnvironmentKey.self]
        }
        set {
            self[WindowEnvironmentKey.self] = newValue
        }
    }
    
    private struct WindowEnvironmentKey: EnvironmentKey {
        
        typealias Value = WindowType
        
        static var defaultValue = WindowType()
        
    }
    
}
