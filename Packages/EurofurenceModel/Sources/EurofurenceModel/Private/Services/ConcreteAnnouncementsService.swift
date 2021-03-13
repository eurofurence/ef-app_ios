import Foundation

class ConcreteAnnouncementsService: AnnouncementsService {

    // MARK: Properties

    private let dataStore: DataStore
    private let imageRepository: ImageRepository
    private var readAnnouncementIdentifiers = [AnnouncementIdentifier]()

    var models = [AnnouncementImpl]() {
        didSet {
            announcementsObservers.forEach(provideLatestData)
        }
    }

    private var announcementsObservers = [AnnouncementsServiceObserver]()

    // MARK: Initialization

    init(eventBus: EventBus, dataStore: DataStore, imageRepository: ImageRepository) {
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        eventBus.subscribe(consumer: DataStoreChangedConsumer { [weak self] in
            self?.reloadAnnouncementsFromStore()
        })

        reloadAnnouncementsFromStore()
        readAnnouncementIdentifiers = dataStore.fetchReadAnnouncementIdentifiers().defaultingTo(.empty)
    }

    // MARK: Functions

    func add(_ observer: AnnouncementsServiceObserver) {
        provideLatestData(to: observer)
        announcementsObservers.append(observer)
    }
    
    func fetchAnnouncement(identifier: AnnouncementIdentifier) -> Announcement? {
        guard let model = models.first(where: { $0.identifier == identifier }) else { return nil }
        
        if readAnnouncementIdentifiers.contains(identifier) == false {
            readAnnouncementIdentifiers.append(identifier)
            announcementsObservers.forEach({ (observer) in
                observer.announcementsServiceDidUpdateReadAnnouncements(readAnnouncementIdentifiers)
            })
            
            dataStore.performTransaction { (transaction) in
                transaction.saveReadAnnouncements(self.readAnnouncementIdentifiers)
            }
        }
        
        return model
    }

    // MARK: Private

    private func reloadAnnouncementsFromStore() {
        guard let announcements = dataStore.fetchAnnouncements() else { return }
        models = announcements.sorted(by: isLastEditTimeAscending).map(makeAnnouncement)
    }
    
    private func makeAnnouncement(from characteristics: AnnouncementCharacteristics) -> AnnouncementImpl {
        AnnouncementImpl(dataStore: dataStore, imageRepository: imageRepository, characteristics: characteristics)
    }

    private func isLastEditTimeAscending(
        _ first: AnnouncementCharacteristics,
        _ second: AnnouncementCharacteristics
    ) -> Bool {
        return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedDescending
    }

    private func provideLatestData(to observer: AnnouncementsServiceObserver) {
        observer.announcementsServiceDidChangeAnnouncements(models)
        observer.announcementsServiceDidUpdateReadAnnouncements(readAnnouncementIdentifiers)
    }

}
