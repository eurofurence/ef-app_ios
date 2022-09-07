import EurofurenceKit
import SwiftUI

struct SplitViewExperience: View {
    
    var body: some View {
        NavigationView {
            Sidebar()
        }
    }
    
}

struct SplitViewExperience_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            SplitViewExperience()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
    
}
