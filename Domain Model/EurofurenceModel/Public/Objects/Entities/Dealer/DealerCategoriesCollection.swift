import Foundation

public protocol DealerCategoriesCollection {
    
    var numberOfCategories: Int { get }
    
    func category(at index: Int) -> DealerCategory
    func add(_ observer: DealerCategoriesCollectionObserver)
    
}

public protocol DealerCategoriesCollectionObserver {
    
    func categoriesCollectionDidChange(_ collection: DealerCategoriesCollection)
    
}
