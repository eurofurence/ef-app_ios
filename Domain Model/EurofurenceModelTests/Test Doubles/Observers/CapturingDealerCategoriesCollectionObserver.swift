import EurofurenceModel

class CapturingDealerCategoriesCollectionObserver: DealerCategoriesCollectionObserver {
    
    private(set) var toldCategoriesDidChange = false
    func categoriesCollectionDidChange(_ collection: DealerCategoriesCollection) {
        toldCategoriesDidChange = true
    }
    
}
