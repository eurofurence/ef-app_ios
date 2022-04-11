import Foundation

class AnnouncementImpl: Announcement {
    
    private unowned let repository: ConcreteAnnouncementsRepository
    private let dataStore: DataStore
    private let imageRepository: ImageRepository
    private let characteristics: AnnouncementCharacteristics
    private var observers = [AnnouncementObserver]()

    var identifier: AnnouncementIdentifier
    var title: String
    var content: String
    var date: Date
    
    var isRead: Bool {
        let readAnnouncements = dataStore.fetchReadAnnouncementIdentifiers() ?? []
        return readAnnouncements.contains(identifier)
    }
    
    init(
        repository: ConcreteAnnouncementsRepository,
        dataStore: DataStore,
        imageRepository: ImageRepository,
        characteristics: AnnouncementCharacteristics
    ) {
        self.repository = repository
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        self.characteristics = characteristics
        
        self.identifier = AnnouncementIdentifier(characteristics.identifier)
        self.title = characteristics.title
        self.content = characteristics.content
        self.date = characteristics.lastChangedDateTime
    }
    
    func add(_ observer: AnnouncementObserver) {
        observers.append(observer)
        
        if isRead {
            observer.announcementEnteredReadState(self)
        } else {
            observer.announcementEnteredUnreadState(self)
        }
    }
    
    func markRead() {
        guard !isRead else { return }
        
        repository.markRead(announcement: self)
        
        for observer in observers {
            observer.announcementEnteredReadState(self)
        }
    }
    
    func fetchAnnouncementImagePNGData(completionHandler: @escaping (Data?) -> Void) {
        var imageData: Data?
        if let imageIdentifier = characteristics.imageIdentifier {
            imageData = imageRepository.loadImage(identifier: imageIdentifier)?.pngImageData
        }
        
        completionHandler(imageData)
    }

}
