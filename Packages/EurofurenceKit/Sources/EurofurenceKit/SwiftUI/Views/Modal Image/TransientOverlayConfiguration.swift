import SwiftUI

struct TransientOverlayConfiguration: Equatable {
    
    static func == (lhs: TransientOverlayConfiguration, rhs: TransientOverlayConfiguration) -> Bool {
        lhs.id == rhs.id
    }
    
    private let id = UUID()
    var isPresented: Binding<Bool>
    var makeOverlay: (Namespace.ID) -> AnyView
    
}
