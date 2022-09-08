import EurofurenceKit
import SwiftUI

struct SplitViewExperience: View {
    
    @State private var selectedSidebarItem: Sidebar.Item? = .news
    
    var body: some View {
        NavigationView {
            Sidebar(selectedItem: $selectedSidebarItem)
            
            EmptyView()
            
            EmptyView()
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
