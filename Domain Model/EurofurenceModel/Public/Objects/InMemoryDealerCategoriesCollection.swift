import Foundation

public struct InMemoryDealerCategoriesCollection<C>: DealerCategoriesCollection
    where C: RandomAccessCollection, C.Element == DealerCategory, C.Index == Int {
    
    private var categories: C
    
    public init(categories: C) {
        self.categories = categories
    }
    
    public var numberOfCategories: Int {
        return categories.count
    }
    
    public func category(at index: Int) -> DealerCategory {
        return categories[index]
    }
    
}
