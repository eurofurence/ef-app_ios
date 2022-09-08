import EurofurenceKit
import SwiftUI

struct DealersView: View {
    
    @State private var selectedCategory: DealerCategory?
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    DealersCollectionView()
                } label: {
                    Label {
                        Text("Dealers")
                    } icon: {
                        Image(systemName: "cart")
                    }
                }
            }
            
            Section {
                DealerCategoriesView(selectedCategory: $selectedCategory)
            } header: {
                Text("Categories")
            }
            .headerProminence(.increased)
        }
        .navigationTitle("Dealers")
        .refreshesModel()
    }
    
}

struct DealersView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                DealersView()
            }
        }
    }
    
}
