import EurofurenceKit
import SwiftUI

private extension Sidebar.Item {
    
    static let dealers = Sidebar.Item("Dealers")
    static func dealerCategory(category: String) -> Sidebar.Item { Sidebar.Item(category) }
    
}

struct DealerSidebarItems: View {
    
    var selectedItem: Binding<Sidebar.Item?>
    
    @FetchRequest(
        entity: DealerCategory.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \DealerCategory.name, ascending: true)
        ]
    )
    private var categories: FetchedResults<DealerCategory>
    
    var body: some View {
        Section {
            NavigationLink(tag: Sidebar.Item.dealers, selection: selectedItem) {
                Text("Dealers")
            } label: {
                Label {
                    Text("Dealers")
                } icon: {
                    Image(systemName: "cart")
                }
            }
            
            ForEach(categories) { category in
                NavigationLink(tag: Sidebar.Item.dealerCategory(category: category.name), selection: selectedItem) {
                    Text(verbatim: category.name)
                } label: {
                    CanonicalDealerCategoryLabel(category: category.canonicalCategory)
                }
            }
        } header: {
            Text("Dealers")
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
