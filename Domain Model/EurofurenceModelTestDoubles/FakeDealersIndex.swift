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
    
    public init(title: String = "") {
        name = title
    }
    
    public var name: String
    private var isActive = false
    
    public func activate() {
        
    }
    
    public func deactivate() {
        
    }
    
    public func add(_ observer: DealerCategoryObserver) {
        if isActive {
            observer.categoryDidActivate(self)
        } else {
            observer.categoryDidDeactivate(self)
        }
    }
    
    public func transitionToActiveState() {
        isActive = true
    }
    
    public func transitionToInactiveState() {
        isActive = false
    }
    
}
