import EurofurenceKit
import SwiftUI

struct MoreView: View {
    
    var body: some View {
        List {
            NavigationLink {
                MapsView()
            } label: {
                MapsLabel()
            }
            
            NavigationLink {
                Text("Collect-them-all")
            } label: {
                CollectThemAllLabel()
            }
            
            NavigationLink {
                Text("Services")
            } label: {
                AdditionalServicesLabel()
            }
        }
        .navigationTitle("More")
    }
    
}

struct MoreView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                MoreView()
            }
        }
    }
    
}
