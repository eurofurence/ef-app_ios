import CoreData
import SwiftUI

extension View {
    
    /// Injects the model into the SwiftUI environment in preparation for rendering.
    ///
    /// This modifier function should be called once at the root of a SwiftUI view tree, usually from a scene.
    ///
    /// - Parameter model: The model to expose to the view.
    /// - Returns: A `View` with the associated model configured within the environment.
    @MainActor
    public func environmentModel(_ model: EurofurenceModel) -> some View {
        self
            .environmentObject(model)
            .environment(\.managedObjectContext, model.viewContext)
    }
    
}
