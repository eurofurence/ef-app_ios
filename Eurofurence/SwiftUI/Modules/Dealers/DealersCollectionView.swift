import EurofurenceKit
import SwiftUI

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
                        NavigationLink {
                            Text(dealer.name)
                        } label: {
                            Text(dealer.name)
                        }
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
