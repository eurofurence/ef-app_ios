import EurofurenceKit
import SwiftUI

struct TopLevelSidebarItems: View {
    
    private enum Item: Hashable {
        case news
        case information
        case maps
        case game
        case services
    }
    
    @State private var selectedItem: Item?
    
    var body: some View {
        NavigationLink(tag: Item.news, selection: $selectedItem) {
            Text("News")
        } label: {
            NewsLabel(isSelected: selectedItem == .news)
        }
        
        NavigationLink(tag: Item.information, selection: $selectedItem) {
            InformationView()
        } label: {
            InformationLabel(isSelected: selectedItem == .information)
        }
        
        NavigationLink(tag: Item.maps, selection: $selectedItem) {
            Text("Maps")
        } label: {
            MapsLabel(isSelected: selectedItem == .maps)
        }
        
        NavigationLink(tag: Item.game, selection: $selectedItem) {
            Text("Collect-them-All")
        } label: {
            CollectThemAllLabel(isSelected: selectedItem == .game)
        }
        
        NavigationLink(tag: Item.services, selection: $selectedItem) {
            Text("Services")
        } label: {
            AdditionalServicesLabel(isSelected: selectedItem == .services)
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
