import SwiftUI

struct ModallyPresentedImage: Equatable {
    
    static func == (lhs: ModallyPresentedImage, rhs: ModallyPresentedImage) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: AnyHashable
    var isPresented: Binding<Bool>
    var image: SwiftUI.Image
    
}
