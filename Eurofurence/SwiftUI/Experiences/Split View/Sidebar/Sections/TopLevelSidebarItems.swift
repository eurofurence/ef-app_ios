import EurofurenceKit
import SwiftUI

extension Sidebar.Item {
    
    static let news = Sidebar.Item("News")
    static let information = Sidebar.Item("Information")
    static let maps = Sidebar.Item("Maps")
    static let game = Sidebar.Item("Game")
    static let services = Sidebar.Item("Services")
    
}

struct TopLevelSidebarItems: View {
    
    @Binding var selectedItem: Sidebar.Item?
    
    var body: some View {
        NavigationLink(tag: Sidebar.Item.news, selection: $selectedItem) {
            Text("News")
        } label: {
            Label {
                Text("News")
            } icon: {
                Image(systemName: "newspaper")
            }
        }
        
        NavigationLink(tag: Sidebar.Item.information, selection: $selectedItem) {
            Text("Information")
        } label: {
            Label {
                Text("Information")
            } icon: {
                Image(systemName: "info.circle")
            }
        }
        
        NavigationLink(tag: Sidebar.Item.maps, selection: $selectedItem) {
            Text("Maps")
        } label: {
            Label {
                Text("Maps")
            } icon: {
                Image(systemName: "map")
            }
        }
        
        NavigationLink(tag: Sidebar.Item.game, selection: $selectedItem) {
            Text("Collect-them-All")
        } label: {
            Label {
                Text("Collect-them-All")
            } icon: {
                Image("Collectemall-50")
            }
        }
        
        NavigationLink(tag: Sidebar.Item.information, selection: $selectedItem) {
            Text("Services")
        } label: {
            Label {
                Text("Services")
            } icon: {
                Image(systemName: "books.vertical")
            }
        }
    }
    
}

struct TopLevelSidebarItems_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                List {
                    TopLevelSidebarItems(selectedItem: .constant(nil))
                }
                .listStyle(.sidebar)
            }
            .navigationViewStyle(.stack)
            .previewLayout(.sizeThatFits)
        }
    }
    
}
