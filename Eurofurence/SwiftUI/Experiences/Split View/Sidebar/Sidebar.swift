import EurofurenceKit
import SwiftUI

struct Sidebar: View {
    
    var body: some View {
        List {
            TopLevelSidebarItems()
            DealerSidebarItems()
            ScheduleSidebarItems()
        }
        .listStyle(.sidebar)
        .navigationTitle("Eurofurence")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                CloudStatusView()
            }
        }
    }
    
}

struct Sidebar_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                Sidebar()
                    .previewLayout(.sizeThatFits)
            }
            .navigationViewStyle(.stack)
        }
    }
    
}
