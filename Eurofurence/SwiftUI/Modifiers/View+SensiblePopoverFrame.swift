import SwiftUI

extension View {
    
    /// Applies a `frame` modifier to this view for use in applying a size constraint for containment within a popover.
    func sensiblePopoverFrame() -> some View {
        self
            .frame(
                minWidth: 320,
                idealWidth: 400,
                maxWidth: nil,
                minHeight: 500,
                idealHeight: 700,
                maxHeight: nil,
                alignment: .top
            )
    }
    
}
