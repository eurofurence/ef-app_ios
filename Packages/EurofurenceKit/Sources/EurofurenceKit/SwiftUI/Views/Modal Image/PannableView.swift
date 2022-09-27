import SwiftUI

/// A `View` that enables panning and zooming of another view.
public struct PannableView<Content>: View where Content: View {
    
    private let content: Content
    private let geometry: GeometryProxy
    private let magnificationLimit: CGFloat = 3
    @State private var currentImageViewSize: CGSize = .zero
    
    @State private var magnification = 1.0
    @State private var inProgressMagnification = 1.0
    
    @State private var translationFromIdentity = CGSize.zero
    @State private var inProgressDrag: DragGesture.Value?
    
    public init(_ content: Content, geometry: GeometryProxy) {
        self.geometry = geometry
        self.content = content
    }
    
    public init(geometry: GeometryProxy, @ViewBuilder _ content: () -> Content) {
        self.geometry = geometry
        self.content = content()
    }
    
    public var body: some View {
        content
            .measure { newValue in
                currentImageViewSize = newValue
            }
            .aspectRatio(contentMode: .fit)
            .scaleEffect(currentGestureMagnification)
            .offset(currentGestureTranslation)
            .onChange(of: magnification) { _ in
                withAnimation {
                    translationFromIdentity = finalDragTranslation(
                        proposedTranslation: .zero
                    )
                }
            }
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
                        proposedTranslation: value.predictedEndTranslation
                    )
                    
                    withAnimation(.easeOut) {
                        inProgressDrag = nil
                        translationFromIdentity = translation
                    }
                })
            .edgesIgnoringSafeArea(.all)
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
    
    private func finalDragTranslation(proposedTranslation: CGSize) -> CGSize {
        var finalTranslation = translationFromIdentity
        finalTranslation.width += proposedTranslation.width
        finalTranslation.height += proposedTranslation.height
        
        let viewSize = CGSize(
            width: currentImageViewSize.width * magnification,
            height: currentImageViewSize.height * magnification
        )
        
        adjustHorizontalComponent(proposedTranslation: &finalTranslation, viewSize: viewSize)
        adjustVerticalComponent(proposedTranslation: &finalTranslation, viewSize: viewSize)
        
        return finalTranslation
    }
    
    private func adjustHorizontalComponent(proposedTranslation: inout CGSize, viewSize: CGSize) {
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
    
    private func adjustVerticalComponent(proposedTranslation: inout CGSize, viewSize: CGSize) {
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
