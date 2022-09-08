import EurofurenceKit
import SwiftUI

struct Sidebar: View {
    
    struct Item: Hashable {
        
        private let stringValue: String
        
        init(_ stringValue: String) {
            self.stringValue = stringValue
        }
        
    }
    
    @State private var selectedItem: Item?
    
    var body: some View {
        List {
            TopLevelSidebarItems(selectedItem: $selectedItem)
            DealerSidebarItems(selectedItem: $selectedItem)
            ScheduleSidebarItems(selectedItem: $selectedItem)
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
