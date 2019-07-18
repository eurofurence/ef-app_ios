import EurofurenceModel
import Foundation

public class FakeDealersIndex: DealersIndex {

    public let alphabetisedDealers: [AlphabetisedDealersGroup]

    public init(
        alphabetisedDealers: [AlphabetisedDealersGroup] = .random,
        availableCategories: DealerCategoriesCollection = InMemoryDealerCategoriesCollection(categories: [FakeDealerCategory]())
    ) {
        self.alphabetisedDealers = alphabetisedDealers
        self.availableCategories = availableCategories
    }
    
    public var availableCategories: DealerCategoriesCollection

    public let alphabetisedDealersSearchResult: [AlphabetisedDealersGroup] = .random
    public private(set) var capturedSearchTerm: String?
    public func performSearch(term: String) {
        capturedSearchTerm = term
    }

    public func setDelegate(_ delegate: DealersIndexDelegate) {
        delegate.alphabetisedDealersDidChange(to: alphabetisedDealers)
        delegate.indexDidProduceSearchResults(alphabetisedDealersSearchResult)
    }

}

public class FakeDealerCategory: DealerCategory {
    
    public var name: String = ""
    
    public func activate() {
        
    }
    
    public func deactivate() {
        
    }
    
    public func add(_ observer: DealerCategoryObserver) {
        
    }
    
}
