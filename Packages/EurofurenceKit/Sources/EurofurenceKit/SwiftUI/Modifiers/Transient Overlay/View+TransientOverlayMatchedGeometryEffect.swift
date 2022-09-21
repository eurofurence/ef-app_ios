import SwiftUI

extension View {
    
    /// Applies a matched geometry effect modifier to the receiver within the animation namespace of a transient
    /// overlay presentation.
    ///
    /// - Parameters:
    ///   - id: The identifier, often derived from the identifier of the data being displayed by the view.
    ///   - properties: The properties to copy from the source view.
    ///   - anchor: The relative location in the view used to produce its shared position value.
    ///   - isSource: True if the view should be used as the source of geometry for other views in the group.
    /// - Returns: A new view that defines an entry in the global database of views synchronizing their geometry.
    func transientOverlayMatchedGeometryEffect<ID>(
        id: ID,
        properties: MatchedGeometryProperties = .frame,
        anchor: UnitPoint = .center,
        isSource: Bool = true
    ) -> some View where ID: Hashable {
        ModifiedContent(
            content: self,
            modifier: TransientOverlayMatchedGeometryEffectViewModifier(
                id: id,
                properties: properties,
                anchor: anchor,
                isSource: isSource
            )
        )
    }
    
}

private struct TransientOverlayMatchedGeometryEffectViewModifier<ID>: ViewModifier where ID: Hashable {
    
    var id: ID
    @Environment(\.transientOverlayNamespace) private var transientOverlayNamespace: Namespace.ID?
    var properties: MatchedGeometryProperties
    var anchor: UnitPoint
    var isSource: Bool
    
    func body(content: Content) -> some View {
        if let namespace = transientOverlayNamespace {
            content
                .matchedGeometryEffect(
                    id: id,
                    in: namespace,
                    properties: properties,
                    anchor: anchor,
                    isSource: isSource
                )
        } else {
            content
        }
    }
    
}
