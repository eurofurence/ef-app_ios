import EurofurenceKit
import SwiftUI

struct DealerCategoriesView: View {
    
    @FetchRequest(
        entity: DealerCategory.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \DealerCategory.name, ascending: true)
        ]
    )
    private var categories: FetchedResults<DealerCategory>
    
    @Binding var selectedCategory: DealerCategory?
    
    var body: some View {
        ForEach(categories) { category in
            NavigationLink(tag: category, selection: $selectedCategory) {
                DealersCollectionView(category: category)
            } label: {
                CanonicalDealerCategoryLabel(
                    category: category.canonicalCategory,
                    unknownCategoryText: Text(verbatim: category.name)
                )
            }
        }
    }
    
}

struct DealerCategoriesView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                List {
                    DealerCategoriesView(selectedCategory: .constant(nil))
                }
            }
        }
    }
    
}
