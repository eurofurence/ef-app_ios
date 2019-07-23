import Foundation

public class InMemoryDealerCategoriesCollection<C>: DealerCategoriesCollection
    where C: RandomAccessCollection, C.Element: DealerCategory, C.Index == Int {
    
    private var observers = [DealerCategoriesCollectionObserver]()
    
    public var categories: C {
        didSet {
            observers.forEach({ $0.categoriesCollectionDidChange(self) })
        }
    }
    
    public init(categories: C) {
        self.categories = categories
    }
    
    public func add(_ observer: DealerCategoriesCollectionObserver) {
        observers.append(observer)
    }
    
    public var numberOfCategories: Int {
        return categories.count
    }
    
    public func category(at index: Int) -> DealerCategory {
        return categories[index]
    }
    
}
