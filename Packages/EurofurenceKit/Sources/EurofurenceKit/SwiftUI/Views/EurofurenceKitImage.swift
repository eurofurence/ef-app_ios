import SwiftUI

/// A `View` for rendering `Image` types from the EurofurenceKit package.
public struct EurofurenceKitImage: View {
    
    @ObservedObject private var image: EurofurenceKit.Image
    @State private var isShowingFullScreen = false
    
    public init(image: EurofurenceKit.Image) {
        self.image = image
    }
    
    public var body: some View {
        swiftUIImage
            .aspectRatio(contentMode: .fit)
            .cornerRadius(7)
            .onTapGesture {
                isShowingFullScreen = true
            }
            .fullScreenCover(isPresented: $isShowingFullScreen) {
                PannableFullScreenImage(image: swiftUIImage, isPresented: $isShowingFullScreen)
            }
    }
    
    @ViewBuilder
    private var swiftUIImage: some View {
        if let url = image.cachedImageURL {
#if os(iOS)
            if let uiImage = UIImage(contentsOfFile: url.path) {
                SwiftUI.Image(uiImage: uiImage)
                    .resizable()
            }
#elseif os(macOS)
            if let nsImage = NSImage(contentsOf: url) {
                SwiftUI.Image(nsImage: nsImage)
                    .resizable()
            }
#endif
        }
    }
    
    private struct PannableFullScreenImage<Content>: View where Content: View {
        
        var image: Content
        @Binding var isPresented: Bool
        
        private let magnificationScaleLimit: CGFloat = 3
        @State private var currentImageViewSize: CGSize = .zero
        
        @State private var magnification = 1.0
        @State private var inProgressMagnification = 1.0
        
        @State private var translationFromIdentity = CGSize.zero
        @State private var inProgressDrag: DragGesture.Value?
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    image
                        .measure { newValue in
                            currentImageViewSize = newValue
                        }
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(currentGestureMagnification)
                        .offset(currentGestureTranslation)
                        .onChange(of: magnification) { _ in
                            withAnimation {
                                translationFromIdentity = finalDragTranslation(
                                    proposedTranslation: .zero,
                                    geometry: geometry
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
                                    let totalMagnificiation = max(min(magnificationScaleLimit, magnification * scale), 1)
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
                        .edgesIgnoringSafeArea(.all)
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            Button {
                                isPresented.toggle()
                            } label: {
                                SwiftUI.Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.secondary)
                                    .frame(width: 18, height: 18)
                                    .padding()
                                    .background(.thinMaterial)
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
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
                width: currentImageViewSize.width * magnification,
                height: currentImageViewSize.height * magnification
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
    
}
