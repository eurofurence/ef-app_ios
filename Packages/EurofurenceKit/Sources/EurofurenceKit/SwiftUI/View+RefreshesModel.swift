import SwiftUI

extension View {
    
    public func refreshesModel() -> some View {
        ModifiedContent(content: self, modifier: RefreshesModelModifier())
    }
    
}

private struct RefreshesModelModifier: ViewModifier {
    
    @EnvironmentObject private var model: EurofurenceModel
    
    func body(content: Content) -> some View {
        content
            .refreshable {
                do {
                    try await model.updateLocalStore()
                } catch {
                    
                }
            }
    }
    
}
