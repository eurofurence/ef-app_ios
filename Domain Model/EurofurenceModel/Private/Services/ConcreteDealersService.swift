import EventBus
import Foundation

class ConcreteDealersService: DealersService {
    
    private class SimpleDealerCategory: DealerCategory {
        
        private unowned let index: Index
        
        var name: String
        var isActive: Bool {
            didSet {
                index.categoryStateDidChange(self)
            }
        }
        
        init(index: Index, name: String) {
            self.index = index
            self.name = name
            
            isActive = true
        }
        
        func activate() {
            isActive = true
        }
        
        func deactivate() {
            isActive = false
        }
        
    }

    private class Index: DealersIndex, EventConsumer {

        private let dealers: ConcreteDealersService
        private var alphebetisedDealers = [AlphabetisedDealersGroup]()
        private var categories: [DealerCategory] = [] {
            didSet {
                availableCategories = InMemoryDealerCategoriesCollection(categories: categories)
            }
        }

        init(dealers: ConcreteDealersService, eventBus: EventBus) {
            self.dealers = dealers
            availableCategories = InMemoryDealerCategoriesCollection(categories: [])
            updateCategories()

            eventBus.subscribe(consumer: self)
        }
        
        private(set) var availableCategories: DealerCategoriesCollection

        func performSearch(term: String) {
            let matches = alphebetisedDealers.compactMap { (group) -> AlphabetisedDealersGroup? in
                let matchingDealers = group.dealers.compactMap { (dealer) -> Dealer? in
                    let preferredNameMatches = dealer.preferredName.localizedCaseInsensitiveContains(term)
                    var alternateNameMatches = false
                    if let alternateName = dealer.alternateName {
                        alternateNameMatches = alternateName.localizedCaseInsensitiveContains(term)
                    }

                    guard preferredNameMatches || alternateNameMatches else { return nil }

                    return dealer
                }

                guard matchingDealers.isEmpty == false else { return nil }
                return AlphabetisedDealersGroup(indexingString: group.indexingString, dealers: matchingDealers)
            }

            delegate?.indexDidProduceSearchResults(matches)
        }

        private var delegate: DealersIndexDelegate?
        func setDelegate(_ delegate: DealersIndexDelegate) {
            self.delegate = delegate
            updateAlphebetisedDealers()
        }

        func consume(event: ConcreteDealersService.UpdatedEvent) {
            updateCategories()
            updateAlphebetisedDealers()
        }
        
        private func updateAlphebetisedDealers() {
            let activeCategories = Set(categories.filter({ $0.isActive }).map({ $0.name }))
            let dealersWithEnabledCategory = dealers.dealerModels.filter({ (dealer) -> Bool in
                let dealerCategories = Set(dealer.categories)
                return dealerCategories.isDisjoint(with: activeCategories) == false
            })
            
            let grouped = Dictionary(grouping: dealersWithEnabledCategory, by: { (dealer) -> String in
                guard let firstCharacterOfName = dealer.preferredName.first else { fatalError("Dealer does not have a name!") }
                return String(firstCharacterOfName).uppercased()
            })
            
            let sortedGroups = grouped.sorted(by: { $0.key < $1.key })
            alphebetisedDealers = sortedGroups.map({ (arg) -> AlphabetisedDealersGroup in
                let (index, dealers) = arg
                return AlphabetisedDealersGroup(indexingString: index,
                                                dealers: dealers.sorted(by: { (first, second) -> Bool in
                                                    return first.preferredName.lowercased() < second.preferredName.lowercased()
                                                }))
            })
            
            delegate?.alphabetisedDealersDidChange(to: alphebetisedDealers)
        }
        
        private func updateCategories() {
            let categoryTitles = Set(dealers.dealerModels.flatMap({ $0.categories }))
            categories = categoryTitles.sorted().map({ SimpleDealerCategory(index: self, name: $0) })
        }
        
        func categoryStateDidChange(_ category: DealerCategory) {
            updateAlphebetisedDealers()
        }

    }

    private struct UpdatedEvent {}

    private var dealerModels = [DealerImpl]()
    private let eventBus: EventBus
    private let dataStore: DataStore
    private let imageCache: ImagesCache
    private let mapCoordinateRender: MapCoordinateRender?
    private let shareableURLFactory: ShareableURLFactory

    init(eventBus: EventBus,
         dataStore: DataStore,
         imageCache: ImagesCache,
         mapCoordinateRender: MapCoordinateRender?,
         shareableURLFactory: ShareableURLFactory) {
        self.eventBus = eventBus
        self.dataStore = dataStore
        self.imageCache = imageCache
        self.mapCoordinateRender = mapCoordinateRender
        self.shareableURLFactory = shareableURLFactory

        eventBus.subscribe(consumer: DataStoreChangedConsumer(handler: reloadDealersFromDataStore))
        reloadDealersFromDataStore()
    }
    
    func fetchDealer(for identifier: DealerIdentifier) -> Dealer? {
        return dealerModels.first(where: { $0.identifier == identifier })
    }

    func makeDealersIndex() -> DealersIndex {
        return Index(dealers: self, eventBus: eventBus)
    }

    private func reloadDealersFromDataStore() {
        guard let dealers = dataStore.fetchDealers() else { return }

        dealerModels = dealers.map(makeDealer)
        eventBus.post(ConcreteDealersService.UpdatedEvent())
    }
    
    private func makeDealer(from characteristics: DealerCharacteristics) -> DealerImpl {
        return DealerImpl(eventBus: eventBus,
                          dataStore: dataStore,
                          imageCache: imageCache,
                          mapCoordinateRender: mapCoordinateRender,
                          characteristics: characteristics,
                          shareableURLFactory: shareableURLFactory)
    }

}
