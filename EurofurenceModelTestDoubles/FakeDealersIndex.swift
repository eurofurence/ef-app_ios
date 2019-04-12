import EurofurenceModel
import Foundation

public class FakeDealersIndex: DealersIndex {

    public let alphabetisedDealers: [AlphabetisedDealersGroup]

    public init(alphabetisedDealers: [AlphabetisedDealersGroup] = .random) {
        self.alphabetisedDealers = alphabetisedDealers
    }

    public let alphabetisedDealersSearchResult: [AlphabetisedDealersGroup] = .random
    private(set) public var capturedSearchTerm: String?
    public func performSearch(term: String) {
        capturedSearchTerm = term
    }

    public func setDelegate(_ delegate: DealersIndexDelegate) {
        delegate.alphabetisedDealersDidChange(to: alphabetisedDealers)
        delegate.indexDidProduceSearchResults(alphabetisedDealersSearchResult)
    }

}
