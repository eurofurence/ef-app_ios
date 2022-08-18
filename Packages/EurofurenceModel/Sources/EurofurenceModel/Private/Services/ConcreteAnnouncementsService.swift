import Foundation

class ConcreteAnnouncementsRepository: AnnouncementsRepository {

    // MARK: Properties

    private let dataStore: DataStore
    private let imageRepository: ImageRepository
    private var subscription: Any?
    private var readAnnouncementIdentifiers = [AnnouncementIdentifier]()

    var models = [AnnouncementImpl]() {
        didSet {
            announcementsObservers.forEach(provideLatestData)
        }
    }

    private var announcementsObservers = [AnnouncementsRepositoryObserver]()

    // MARK: Initialization

    init(eventBus: EventBus, dataStore: DataStore, imageRepository: ImageRepository) {
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        
        let updateCachedAnnouncements = DataStoreChangedConsumer("ConcreteAnnouncementsRepository") { [weak self] in
            self?.reloadAnnouncementsFromStore()
        }
        
        subscription = eventBus.subscribe(consumer: updateCachedAnnouncements)

        reloadAnnouncementsFromStore()
        readAnnouncementIdentifiers = dataStore.fetchReadAnnouncementIdentifiers().defaultingTo(.empty)
    }

    // MARK: Functions

    func add(_ observer: AnnouncementsRepositoryObserver) {
        provideLatestData(to: observer)
        announcementsObservers.append(observer)
    }
    
    func fetchAnnouncement(identifier: AnnouncementIdentifier) -> Announcement? {
        models.first(where: { $0.identifier == identifier })
    }
    
    func markRead(announcement: AnnouncementImpl) {
        readAnnouncementIdentifiers.append(announcement.identifier)
        announcementsObservers.forEach({ (observer) in
            observer.announcementsServiceDidUpdateReadAnnouncements(readAnnouncementIdentifiers)
        })
        
        dataStore.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(self.readAnnouncementIdentifiers)
        }
    }

    // MARK: Private

    private func reloadAnnouncementsFromStore() {
        guard let announcements = dataStore.fetchAnnouncements() else { return }
        models = announcements.sorted(by: isLastEditTimeAscending).map(makeAnnouncement)
    }
    
    private func makeAnnouncement(from characteristics: AnnouncementCharacteristics) -> AnnouncementImpl {
        AnnouncementImpl(
            repository: self,
            dataStore: dataStore,
            imageRepository: imageRepository,
            characteristics: characteristics
        )
    }

    private func isLastEditTimeAscending(
        _ first: AnnouncementCharacteristics,
        _ second: AnnouncementCharacteristics
    ) -> Bool {
        return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedDescending
    }

    private func provideLatestData(to observer: AnnouncementsRepositoryObserver) {
        observer.announcementsServiceDidChangeAnnouncements(models)
        observer.announcementsServiceDidUpdateReadAnnouncements(readAnnouncementIdentifiers)
    }

}
