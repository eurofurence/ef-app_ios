import CoreData
import SwiftUI

extension EnvironmentValues {
    
    /// Accesses the model associated with the current environment.
    public var model: EurofurenceModel {
        get {
            self[EurofurenceModelEnvironmentKey.self]
        }
        set {
            self[EurofurenceModelEnvironmentKey.self] = newValue
        }
    }
    
    private struct EurofurenceModelEnvironmentKey: EnvironmentKey {
        
        typealias Value = EurofurenceModel
        
        static var defaultValue: EurofurenceModel {
            fatalError("EurofurenceModel must be initialized by the application, no default value is permitted")
        }
        
    }
    
}

extension View {
    
    /// Injects the model into the SwiftUI environment in preparation for rendering.
    ///
    /// This modifier function should be called once at the root of a SwiftUI view tree, usually from a scene.
    ///
    /// - Parameter model: The model to expose to the view.
    /// - Returns: A `View` with the associated model configured within the environment.
    public func environmentModel(_ model: EurofurenceModel) -> some View {
        self
            .environmentObject(model)
            .environment(\.managedObjectContext, model.viewContext)
    }
    
}
