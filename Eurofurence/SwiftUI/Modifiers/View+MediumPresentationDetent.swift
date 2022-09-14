import SwiftUI

extension View {
    
    @ViewBuilder
    func filteringInterfaceDetents() -> some View {
        if #available(iOS 16.0, *) {
            self
                .presentationDetents([.medium])
        } else {
            self
        }
    }
    
}
