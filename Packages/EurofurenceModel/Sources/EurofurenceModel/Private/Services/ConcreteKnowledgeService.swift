import Foundation

class ConcreteKnowledgeService: KnowledgeService {

    // MARK: Properties

    private let dataStore: DataStore
    private let imageRepository: ImageRepository
    private var subscription: Any?
    private var observers = [KnowledgeServiceObserver]()
    private let shareableURLFactory: ShareableURLFactory
    
    var models = [KnowledgeGroup]() {
        didSet {
            observers.forEach { $0.knowledgeGroupsDidChange(to: models) }
        }
    }

    // MARK: Initialization

    init(
        eventBus: EventBus,
        dataStore: DataStore,
        imageRepository: ImageRepository,
        shareableURLFactory: ShareableURLFactory
    ) {
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        self.shareableURLFactory = shareableURLFactory
        
        let updateCachedKnowledgeEntries = DataStoreChangedConsumer("ConcreteKnowledgeService") { [weak self] in
            self?.reloadKnowledgeBaseFromDataStore()
        }
        
        subscription = eventBus.subscribe(consumer: updateCachedKnowledgeEntries)

        reloadKnowledgeBaseFromDataStore()
    }

    // MARK: Functions

    func add(_ observer: KnowledgeServiceObserver) {
        observers.append(observer)
        observer.knowledgeGroupsDidChange(to: models)
    }

    func fetchKnowledgeEntry(
        for identifier: KnowledgeEntryIdentifier,
        completionHandler: @escaping (KnowledgeEntry) -> Void
    ) {
        models.reduce(.empty, { $0 + $1.entries }).first(where: { $0.identifier == identifier }).map(completionHandler)
    }

    func fetchKnowledgeGroup(
        identifier: KnowledgeGroupIdentifier,
        completionHandler: @escaping (KnowledgeGroup) -> Void
    ) {
        models.first(where: { $0.identifier == identifier }).map(completionHandler)
    }

    func fetchImagesForKnowledgeEntry(
        identifier: KnowledgeEntryIdentifier,
        completionHandler: @escaping ([Data]) -> Void
    ) {
        let imageIdentifiers: [String] = {
            guard let entries = dataStore.fetchKnowledgeEntries() else { return .empty }
            guard let entry = entries.first(where: { $0.identifier == identifier.rawValue }) else { return .empty }

            return entry.imageIdentifiers
        }()

        let images = imageIdentifiers.compactMap(imageRepository.loadImage).map(\.pngImageData)
        completionHandler(images)
    }

    // MARK: Private

    private func reloadKnowledgeBaseFromDataStore() {
        guard let groups = dataStore.fetchKnowledgeGroups(),
              let entries = dataStore.fetchKnowledgeEntries() else {
                return
        }

        models = KnowledgeGroupImpl.fromServerModels(
            groups: groups,
            entries: entries,
            shareableURLFactory: shareableURLFactory
        )
    }

}
