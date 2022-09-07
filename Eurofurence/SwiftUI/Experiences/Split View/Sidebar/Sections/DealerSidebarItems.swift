import EurofurenceKit
import SwiftUI

private extension Sidebar.Item {
    
    static let dealers = Sidebar.Item("Dealers")
    static func dealerCategory(category: String) -> Sidebar.Item { Sidebar.Item(category) }
    
}

struct DealerSidebarItems: View {
    
    var selectedItem: Binding<Sidebar.Item?>
    private let exampleCategories: [SampleDealerCategory] = SampleDealerCategory.all
    
    private struct SampleDealerCategory: Hashable, Identifiable {
        
        var id: some Hashable {
            self
        }
        
        var name: String
        var symbolName: String
        
        static var all: [SampleDealerCategory] = {
            return [
                SampleDealerCategory(name: "Prints", symbolName: "printer"),
                SampleDealerCategory(name: "Fursuits", symbolName: "pawprint"),
                SampleDealerCategory(name: "Commissions", symbolName: "photo.artframe"),
                SampleDealerCategory(name: "Artwork", symbolName: "paintbrush"),
                SampleDealerCategory(name: "Miscellaneous", symbolName: "ellipsis.rectangle"),
            ]
        }()
        
    }
    
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
            
            ForEach(exampleCategories) { category in
                NavigationLink(tag: Sidebar.Item.dealerCategory(category: category.name), selection: selectedItem) {
                    Text(verbatim: category.name)
                } label: {
                    Label {
                        Text(verbatim: category.name)
                    } icon: {
                        Image(systemName: category.symbolName)
                    }
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
