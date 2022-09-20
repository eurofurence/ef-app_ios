import EurofurenceKit
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        HandheldExperience()
            .applicationTransientOverlays()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            ContentView()
        }
    }
    
}
