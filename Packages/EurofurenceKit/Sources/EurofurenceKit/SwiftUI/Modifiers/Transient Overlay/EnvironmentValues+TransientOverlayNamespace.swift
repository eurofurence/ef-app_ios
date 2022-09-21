import SwiftUI

extension EnvironmentValues {
    
    var transientOverlayNamespace: Namespace.ID? {
        get {
            self[ModalImageNamespaceEnvironmentKey.self]
        }
        set {
            self[ModalImageNamespaceEnvironmentKey.self] = newValue
        }
    }
    
    private struct ModalImageNamespaceEnvironmentKey: EnvironmentKey {
        
        typealias Value = Namespace.ID?
        
        static var defaultValue: Namespace.ID?
        
    }
    
}
