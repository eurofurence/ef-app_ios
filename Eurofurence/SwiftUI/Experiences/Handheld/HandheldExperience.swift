import EurofurenceKit
import SwiftUI

struct HandheldExperience: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        switch horizontalSizeClass {
        case .regular:
            SplitViewExperience()
            
        default:
            TabExperience()
        }
    }
    
}

struct HandheldExperience_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            HandheldExperience()
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
                .previewInterfaceOrientation(.portrait)
            
            HandheldExperience()
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
                .previewInterfaceOrientation(.landscapeLeft)
            
            HandheldExperience()
                .previewDevice("iPhone 13")
        }
    }
    
}
