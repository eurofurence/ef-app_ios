import EurofurenceKit
import SwiftUI

struct DealerSidebarItems: View {
    
    @State private var selectedCategory: DealerCategory?
    
    var body: some View {
        Section {
            NavigationLink {
                DealersCollectionView()
            } label: {
                DealersLabel()
            }
            
            Divider()
            
            DealerCategoriesView(selectedCategory: $selectedCategory)
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
                    DealerSidebarItems()
                }
                .listStyle(.sidebar)
            }
            .navigationViewStyle(.stack)
            .previewLayout(.sizeThatFits)
        }
    }
    
}
