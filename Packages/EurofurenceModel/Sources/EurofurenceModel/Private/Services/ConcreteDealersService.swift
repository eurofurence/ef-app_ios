import Foundation

class ConcreteDealersService: DealersService {
    
    private class SimpleDealerCategory: DealerCategory {
        
        private var observers = [DealerCategoryObserver]()
        
        var name: String
        var isActive: Bool = true {
            didSet {
                observers.forEach(updateObserverWithCurrentState)
            }
        }
        
        init(name: String) {
            self.name = name
        }
        
        func activate() {
            isActive = true
            observers.forEach({ $0.categoryDidActivate(self) })
        }
        
        func deactivate() {
            isActive = false
            observers.forEach({ $0.categoryDidDeactivate(self) })
        }
        
        func add(_ observer: DealerCategoryObserver) {
            observers.append(observer)
            updateObserverWithCurrentState(observer)
        }
        
        private func updateObserverWithCurrentState(_ observer: DealerCategoryObserver) {
            if isActive {
                observer.categoryDidActivate(self)
            } else {
                observer.categoryDidDeactivate(self)
            }
        }
        
    }

    private class Index: DealersIndex, DealerCategoryObserver {

        private var subscription: Any?
        private let dealers: ConcreteDealersService
        private let categoriesCollection = InMemoryDealerCategoriesCollection(categories: [SimpleDealerCategory]())
        private var alphebetisedDealers = [AlphabetisedDealersGroup]()
        private var categories: [SimpleDealerCategory] {
            get {
                return categoriesCollection.categories
            } set {
                categoriesCollection.categories = newValue
            }
        }

        init(dealers: ConcreteDealersService, eventBus: EventBus) {
            self.dealers = dealers
            updateCategories()

            subscription = eventBus.subscribe(consumer: UpdatesVisibleDealers(index: self))
        }
        
        private struct UpdatesVisibleDealers: EventConsumer {
            
            unowned var index: Index
            
            func consume(event: ConcreteDealersService.UpdatedEvent) {
                index.updateCategories()
                index.updateAlphebetisedDealers()
            }
            
        }
        
        var availableCategories: DealerCategoriesCollection {
            return categoriesCollection
        }

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

        private func updateAlphebetisedDealers() {
            let activeCategories = Set(categories.filter(\.isActive).map(\.name))
            let dealersWithEnabledCategory = dealers.dealerModels.filter({ (dealer) -> Bool in
                let dealerCategories = Set(dealer.categories)
                return dealerCategories.isDisjoint(with: activeCategories) == false
            })
            
            let grouped = Dictionary(grouping: dealersWithEnabledCategory, by: { (dealer) -> String in
                guard let firstCharacterOfName = dealer.preferredName.first else {
                    fatalError("Dealer does not have a name!")
                }
                
                return String(firstCharacterOfName).uppercased()
            })
            
            let sortedGroups = grouped.sorted(by: { $0.key < $1.key })
            alphebetisedDealers = sortedGroups.map({ (arg) -> AlphabetisedDealersGroup in
                let (index, dealers) = arg
                return AlphabetisedDealersGroup(
                    indexingString: index,
                    dealers: dealers.sorted(by: { (first, second) -> Bool in
                        return first.preferredName.lowercased() < second.preferredName.lowercased()
                    })
                )
            })
            
            delegate?.alphabetisedDealersDidChange(to: alphebetisedDealers)
        }
        
        private func updateCategories() {
            let categoryTitles = Set(dealers.dealerModels.flatMap({ $0.categories }))
            var categories = [SimpleDealerCategory]()
            for title in categoryTitles {
                if let existingCategory = self.categories.first(where: { $0.name == title }) {
                    categories.append(existingCategory)
                } else {
                    let category = SimpleDealerCategory(name: title)
                    category.add(self)
                    categories.append(category)
                }
            }
            
            self.categories = categories.sorted(by: { $0.name < $1.name })
        }
        
        func categoryDidActivate(_ category: DealerCategory) {
            updateAlphebetisedDealers()
        }
        
        func categoryDidDeactivate(_ category: DealerCategory) {
            updateAlphebetisedDealers()
        }

    }

    private struct UpdatedEvent {}

    private var subscription: Any?
    private var dealerModels = [DealerImpl]()
    private let eventBus: EventBus
    private let dataStore: DataStore
    private let imageCache: ImagesCache
    private let mapCoordinateRender: MapCoordinateRender?
    private let shareableURLFactory: ShareableURLFactory
    private let urlOpener: URLOpener?

    init(
        eventBus: EventBus,
        dataStore: DataStore,
        imageCache: ImagesCache,
        mapCoordinateRender: MapCoordinateRender?,
        shareableURLFactory: ShareableURLFactory,
        urlOpener: URLOpener?
    ) {
        self.eventBus = eventBus
        self.dataStore = dataStore
        self.imageCache = imageCache
        self.mapCoordinateRender = mapCoordinateRender
        self.shareableURLFactory = shareableURLFactory
        self.urlOpener = urlOpener

        let updateCachedDealers = DataStoreChangedConsumer("ConcreteDealersService") { [weak self] in
            self?.reloadDealersFromDataStore()
        }
        
        subscription = eventBus.subscribe(consumer: updateCachedDealers)
        
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
        return DealerImpl(
            eventBus: eventBus,
            dataStore: dataStore,
            imageCache: imageCache,
            mapCoordinateRender: mapCoordinateRender,
            characteristics: characteristics,
            shareableURLFactory: shareableURLFactory,
            urlOpener: urlOpener
        )
    }
    
}
