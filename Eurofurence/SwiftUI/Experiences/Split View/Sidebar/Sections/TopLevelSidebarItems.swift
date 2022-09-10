import EurofurenceKit
import SwiftUI

struct TopLevelSidebarItems: View {
    
    var body: some View {
        NavigationLink {
            Text("News")
        } label: {
            Label {
                Text("News")
            } icon: {
                Image(systemName: "newspaper")
            }
        }
        
        NavigationLink {
            InformationView()
        } label: {
            Label {
                Text("Information")
            } icon: {
                Image(systemName: "info.circle")
            }
        }
        
        NavigationLink {
            Text("Maps")
        } label: {
            Label {
                Text("Maps")
            } icon: {
                Image(systemName: "map")
            }
        }
        
        NavigationLink {
            Text("Collect-them-All")
        } label: {
            Label {
                Text("Collect-them-All")
            } icon: {
                Image("Collectemall-50")
            }
        }
        
        NavigationLink {
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
                    TopLevelSidebarItems()
                }
                .listStyle(.sidebar)
            }
            .navigationViewStyle(.stack)
            .previewLayout(.sizeThatFits)
        }
    }
    
}
