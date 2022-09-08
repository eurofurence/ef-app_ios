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

struct DealersCollectionView: View {
    
    @SectionedFetchRequest(
        entity: Dealer.entity(),
        sectionIdentifier: \Dealer.indexingTitle,
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Dealer.name, ascending: true)
        ],
        predicate: NSPredicate(value: true),
        animation: .spring()
    )
    private var dealerGroup: SectionedFetchResults<String, Dealer>
    
    var category: DealerCategory?
    
    var body: some View {
        List {
            ForEach(dealerGroup) { group in
                Section {
                    ForEach(group) { dealer in
                        Text(dealer.name)
                    }
                } header: {
                    Text(group.id)
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            if let category = category {
                dealerGroup.nsPredicate = NSPredicate(format: "%@ IN SELF.categories", category)
            }
        }
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
