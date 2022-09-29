import SwiftUI

struct IsPanningOutsideContainerPreferenceKey: PreferenceKey {
    
    typealias Value = Bool
    
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value && nextValue()
    }
    
}

extension View {
    
    @ViewBuilder
    func onInteraction(perform: @escaping (CGPoint) -> Void) -> some View {
        if #available(iOS 16.0, *, macOS 13.0, *) {
            modifier(ModernInteractionViewModifier(action: perform))
        } else {
            modifier(LegacyInteractionViewModifier(action: perform))
        }
    }
    
}

@available(iOS 16.0, *, macOS 13.0, *)
private struct ModernInteractionViewModifier: ViewModifier {
    
    let action: (CGPoint) -> Void
    
    func body(content: Content) -> some View {
        content
        // TODO: Fix for macOS
#if os(iOS)
            .onTapGesture { point in
                action(point)
            }
#endif
    }
    
}

private struct LegacyInteractionViewModifier: ViewModifier {
    
    let action: (CGPoint) -> Void
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        let point = value.location
                        action(point)
                    }
            )
    }
    
}

/// A `View` that enables panning and zooming of another view.
public struct PannableView<Content>: View where Content: View {
    
    private let content: Content
    private let magnificationLimit: CGFloat = 3
    @State private var measuredSize: CGSize = .zero
    
    @State private var magnification = 1.0
    @State private var inProgressMagnification = 1.0
    
    @State private var translationFromIdentity = CGSize.zero
    @State private var inProgressDrag: DragGesture.Value?
    
    @State private var isPanningOutsideContainer = false
    @Binding private var selectedProportionalLocation: CGPoint?
    
    public init(
        selectedProportionalLocation: Binding<CGPoint?> = .constant(nil),
        _ content: Content
    ) {
        _selectedProportionalLocation = selectedProportionalLocation
        self.content = content
    }
    
    public init(
        selectedProportionalLocation: Binding<CGPoint?> = .constant(nil),
        @ViewBuilder _ content: () -> Content
    ) {
        _selectedProportionalLocation = selectedProportionalLocation
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            content
                .measure { newValue in
                    measuredSize = newValue
                }
                .aspectRatio(contentMode: .fit)
                .scaleEffect(currentGestureMagnification)
                .offset(currentGestureTranslation)
                .onChange(of: currentGestureMagnification) { newValue in
                    // Determine whether we're panning outside the container, i.e. we occupy >= 75% the total viewport
                    // height. If this is the case, give a hint to the view hiearchy to accomodate for any visual
                    // clipping.
                    let availableHeight = geometry.size.height
                    let scaledHeight = newValue * measuredSize.height
                    let proportion = scaledHeight / availableHeight
                    let relativeContainerProportionVerticalAxis = 0.75
                    isPanningOutsideContainer = proportion >= relativeContainerProportionVerticalAxis
                }
                .onChange(of: magnification) { _ in
                    withAnimation {
                        translationFromIdentity = finalDragTranslation(
                            proposedTranslation: .zero,
                            geometry: geometry
                        )
                    }
                }
                .preference(key: IsPanningOutsideContainerPreferenceKey.self, value: isPanningOutsideContainer)
                .gesture(TapGesture(count: 2)
                    .onEnded { _ in
                        withAnimation {
                            if fabsf(Float(magnification)) > 1 {
                                magnification = 1
                            } else {
                                magnification = 2
                            }
                            
                            translationFromIdentity = .zero
                        }
                    })
                .gesture(MagnificationGesture()
                    .onChanged { scale in
                        inProgressMagnification = scale
                    }
                    .onEnded { scale in
                        withAnimation {
                            let totalMagnificiation = max(min(magnificationLimit, magnification * scale), 1)
                            magnification = totalMagnificiation
                            inProgressMagnification = 1
                        }
                    })
                .simultaneousGesture(DragGesture()
                    .onChanged { value in
                        inProgressDrag = value
                    }
                    .onEnded { value in
                        let translation = finalDragTranslation(
                            proposedTranslation: value.predictedEndTranslation,
                            geometry: geometry
                        )
                        
                        withAnimation(.easeOut) {
                            inProgressDrag = nil
                            translationFromIdentity = translation
                        }
                    })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onInteraction { location in
                    // Transform the coordinate from the coordinate space of the container into the coordinate space
                    // of the target view.
                    let magnifiedSize = CGSize(
                        width: measuredSize.width * magnification,
                        height: measuredSize.height * magnification
                    )
                    
                    // Start by working out the "top" position of the view in the window
                    var top = (geometry.size.height / 2) - (magnifiedSize.height / 2)
                    
                    // Apply any vertical translation from the identity position.
                    top += translationFromIdentity.height
                    
                    // Now work out the true "left" position based on current scaling and magnification.
                    var left = (geometry.size.width / 2) - (magnifiedSize.width / 2)
                    left += translationFromIdentity.width
                    
                    // Subtract the inbound coordinates to transform the points into the local coordinate space.
                    let offset = CGPoint(x: location.x - left, y: location.y - top)
                    
                    // Finally scale these positions relative to the size of the container to work out the proportions.
                    let proportionalOffset = CGPoint(
                        x: offset.x / magnifiedSize.width,
                        y: offset.y / magnifiedSize.height
                    )
                    
                    // Propogate this value through the binding back to the presenting view.
                    selectedProportionalLocation = proportionalOffset
                }
        }
    }
    
    private var currentGestureMagnification: CGFloat {
        magnification * inProgressMagnification
    }
    
    private var currentGestureTranslation: CGSize {
        guard let inProgressTranslation = inProgressDrag else { return translationFromIdentity }
        
        var translation = translationFromIdentity
        translation.width += inProgressTranslation.translation.width
        translation.height += inProgressTranslation.translation.height
        
        return translation
    }
    
    private func finalDragTranslation(proposedTranslation: CGSize, geometry: GeometryProxy) -> CGSize {
        var finalTranslation = translationFromIdentity
        finalTranslation.width += proposedTranslation.width
        finalTranslation.height += proposedTranslation.height
        
        let viewSize = CGSize(
            width: measuredSize.width * magnification,
            height: measuredSize.height * magnification
        )
        
        adjustHorizontalComponent(proposedTranslation: &finalTranslation, viewSize: viewSize, geometry: geometry)
        adjustVerticalComponent(proposedTranslation: &finalTranslation, viewSize: viewSize, geometry: geometry)
        
        return finalTranslation
    }
    
    private func adjustHorizontalComponent(
        proposedTranslation: inout CGSize,
        viewSize: CGSize,
        geometry: GeometryProxy
    ) {
        let w_i = viewSize.width
        let w_v = geometry.size.width
        
        if w_i <= w_v {
            // Image is smaller than the viewport - return to the identity translation.
            proposedTranslation.width = .zero
            return
        }
        
        // The translation represents the vector from the identity position to a new central position.
        // We want to ensure that if the image has been magnified, its leading and trailing edges are outside or
        // flush with the edges of the container view (based on its input geometry).
        // We can calculate this by solving for the new central position of the view based on the drag, and shunting
        // either the horizonal or vertical components of the vector to compensate for any misalignment.
        
        let horizontalCenter = geometry.size.width / 2
        
        let newHorizontalCenter = horizontalCenter + proposedTranslation.width
        let left = newHorizontalCenter - (w_i / 2)
        let right = newHorizontalCenter + (w_i / 2)
        
        if left <= 0 && right >= w_v {
            // Image is zoomed in beyond the viewport - permit the translation.
            return
        }
        
        if left > 0 {
            // Image is zoomed in, but shunted outside the leading bounds. Return to the leading edge.
            proposedTranslation.width -= left
            return
        }
        
        if right < w_v {
            // Image is zoomed in, but shunted inside the trailing bounds. Return to the trailing edge.
            proposedTranslation.width += (w_v - right)
            return
        }
    }
    
    private func adjustVerticalComponent(
        proposedTranslation: inout CGSize,
        viewSize: CGSize,
        geometry: GeometryProxy
    ) {
        let h_i = viewSize.height
        let h_v = geometry.size.height
        
        if h_i <= h_v {
            // Image is smaller than the viewport - return to the identity translation.
            proposedTranslation.height = .zero
            return
        }
        
        // The translation represents the vector from the identity position to a new central position.
        // We want to ensure that if the image has been magnified, its leading and trailing edges are outside or
        // flush with the edges of the container view (based on its input geometry).
        // We can calculate this by solving for the new central position of the view based on the drag, and shunting
        // either the horizonal or vertical components of the vector to compensate for any misalignment.
        
        let verticalCenter = geometry.size.height / 2
        
        let newVerticalCenter = verticalCenter + proposedTranslation.height
        let top = newVerticalCenter - (h_i / 2)
        let bottom = newVerticalCenter + (h_i / 2)
        
        if top <= 0 && bottom >= h_v {
            // Image is zoomed in beyond the viewport - permit the translation.
            return
        }
        
        if top > 0 {
            // Image is zoomed in, but shunted outside the top bounds. Return to the top edge.
            proposedTranslation.height -= top
            return
        }
        
        if bottom < h_v {
            // Image is zoomed in, but shunted inside the bottom bounds. Return to the bottom edge.
            proposedTranslation.height += (h_v - bottom)
            return
        }
    }
    
}
