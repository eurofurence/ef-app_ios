import Foundation

class FetchRemoteModelAndImages: RefreshChain.Node {
    
    private let conventionIdentifier: ConventionIdentifier
    private let forceRefreshRequired: ForceRefreshRequired
    private let dataStore: DataStore
    private let api: API
    private let imageDownloader: ImageDownloader
    private let eventBus: EventBus
    private let imageCache: ImagesCache
    private let clock: Clock
    private let imageRepository: ImageRepository
    
    init(
        next: RefreshChain.Node?,
        conventionIdentifier: ConventionIdentifier,
        forceRefreshRequired: ForceRefreshRequired,
        dataStore: DataStore,
        api: API,
        imageDownloader: ImageDownloader,
        eventBus: EventBus,
        imageCache: ImagesCache,
        clock: Clock,
        imageRepository: ImageRepository
    ) {
        self.conventionIdentifier = conventionIdentifier
        self.forceRefreshRequired = forceRefreshRequired
        self.dataStore = dataStore
        self.api = api
        self.imageDownloader = imageDownloader
        self.eventBus = eventBus
        self.imageCache = imageCache
        self.clock = clock
        self.imageRepository = imageRepository
        
        super.init(next: next)
    }
    
    override func start(progress: Progress, chainComplete: ((RefreshServiceError?) -> Void)?) {
        super.start(progress: progress, chainComplete: chainComplete)
        
        let lastSyncTime = determineLastRefreshDate()
        api.fetchLatestData(lastSyncTime: lastSyncTime) { (response) in
            guard let response = response else {
                self.finish(progress: progress, error: .apiError)
                return
            }
            
            guard self.conventionIdentifier.identifier == response.conventionIdentifier else {
                self.finish(progress: progress, error: .conventionIdentifierMismatch)
                return
            }
            
            self.forceRefreshRequired.markForceRefreshNoLongerRequired()

            self.loadImages(response, lastSyncTime: lastSyncTime, progress: progress)
        }
    }
    
    private func loadImages(_ response: ModelCharacteristics, lastSyncTime: Date?, progress: Progress) {
        let imageDownloadRequests = response.images.changed.map(ImageDownloader.DownloadRequest.init)
        progress.completedUnitCount = 0
        progress.totalUnitCount = Int64(imageDownloadRequests.count)
        
        self.imageDownloader.downloadImages(requests: imageDownloadRequests, parentProgress: progress) {
            self.updateLocalStore(response: response, lastSyncTime: lastSyncTime)
            self.finish(progress: progress, error: nil)
        }
    }
    
    private func determineLastRefreshDate() -> Date? {
        if forceRefreshRequired.isForceRefreshRequired {
            return nil
        } else {
            return dataStore.fetchLastRefreshDate()
        }
    }
    
    private func updateLocalStore(response: ModelCharacteristics, lastSyncTime: Any?) {
        DataStoreSyncBridge(
            dataStore: dataStore,
            clock: clock,
            imageCache: imageCache,
            imageRepository: imageRepository,
            eventBus: eventBus
        ).updateStore(response: response, lastSyncTime: lastSyncTime)
    }
    
}
