import SwiftUI

extension View {
    
    @ViewBuilder
    func enablingMediumPresentationDetent() -> some View {
        if #available(iOS 16.0, *) {
            self
                .presentationDetents([.medium, .large])
        } else {
            self
        }
    }
    
}
