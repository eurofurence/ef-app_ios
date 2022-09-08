import EurofurenceKit
import SwiftUI

private extension Sidebar.Item {
    
    static let dealers = Sidebar.Item("Dealers")
    static func dealerCategory(category: String) -> Sidebar.Item { Sidebar.Item(category) }
    
}

struct DealerSidebarItems: View {
    
    @Binding var selectedItem: Sidebar.Item?
    @State private var selectedCategory: DealerCategory?
    
    var body: some View {
        Section {
            NavigationLink(tag: Sidebar.Item.dealers, selection: $selectedItem) {
                DealersCollectionView()
            } label: {
                Label {
                    Text("Dealers")
                } icon: {
                    Image(systemName: "cart")
                }
            }
            
            Divider()
            
            DealerCategoriesView(selectedCategory: $selectedCategory)
        } header: {
            Text("Dealers")
        }
        .onChange(of: selectedCategory) { newValue in
            if let newValue = newValue {
                selectedItem = Sidebar.Item.dealerCategory(category: newValue.name)
            }
        }
    }
    
}

struct DealerSidebarItems_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                List {
                    DealerSidebarItems(selectedItem: .constant(nil))
                }
                .listStyle(.sidebar)
            }
            .navigationViewStyle(.stack)
            .previewLayout(.sizeThatFits)
        }
    }
    
}
