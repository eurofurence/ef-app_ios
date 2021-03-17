import DealersComponent

class FakeDealerCategoriesViewModel: DealerCategoriesViewModel {
    
    private let categories: [DealerCategoryViewModel]
    
    var numberOfCategories: Int {
        return categories.count
    }
    
    func categoryViewModel(at index: Int) -> DealerCategoryViewModel {
        return categories[index]
    }
    
    init(categories: [DealerCategoryViewModel] = []) {
        self.categories = categories
    }
    
}
