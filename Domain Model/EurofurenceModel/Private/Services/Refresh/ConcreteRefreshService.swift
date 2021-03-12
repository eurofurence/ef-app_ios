import Foundation

class ConcreteRefreshService: RefreshService {
    
    private let longRunningTaskManager: LongRunningTaskManager?
    private let chain: RefreshChain

    init(
        conventionIdentifier: ConventionIdentifier,
        longRunningTaskManager: LongRunningTaskManager?,
        dataStore: DataStore,
        api: API,
        imageDownloader: ImageDownloader,
        clock: Clock,
        eventBus: EventBus,
        imageCache: ImagesCache,
        imageRepository: ImageRepository,
        privateMessagesController: ConcretePrivateMessagesService,
        forceRefreshRequired: ForceRefreshRequired,
        refreshCollaboration: RefreshCollaboration
    ) {
        self.longRunningTaskManager = longRunningTaskManager
        
        let dataStoreBridge = DataStoreSyncBridge(
            dataStore: dataStore,
            clock: clock,
            imageCache: imageCache,
            imageRepository: imageRepository,
            eventBus: eventBus
        )
        
        chain = RefreshChain(
            conventionIdentifier: conventionIdentifier,
            forceRefreshRequired: forceRefreshRequired,
            dataStore: dataStore,
            api: api,
            imageDownloader: imageDownloader,
            eventBus: eventBus,
            imageCache: imageCache,
            privateMessagesController: privateMessagesController,
            refreshCollaboration: refreshCollaboration,
            clock: clock,
            imageRepository: imageRepository,
            dataStoreBridge: dataStoreBridge
        )
    }

    private var refreshObservers = [RefreshServiceObserver]()
    func add(_ observer: RefreshServiceObserver) {
        refreshObservers.append(observer)
    }
    
    private var ongoingProgress: Progress?

    @discardableResult
    func refreshLocalStore(completionHandler: @escaping (RefreshServiceError?) -> Void) -> Progress {
        if let progress = ongoingProgress {
            return progress
        }
        
        let progress = Progress()
        progress.totalUnitCount = -1
        progress.completedUnitCount = -1
        
        ongoingProgress = progress
        
        startLongRunningTask()
        notifyRefreshStarted()
        
        chain.start(progress: progress) { [weak self] (error) in
            completionHandler(error)
            self?.refreshTaskDidFinish()
        }
        
        return progress
    }

    private func refreshTaskDidFinish() {
        ongoingProgress = nil
        notifyRefreshFinished()
        finishLongRunningTask()
    }
    
    private func notifyRefreshFinished() {
        refreshObservers.forEach({ $0.refreshServiceDidFinishRefreshing() })
    }

    private func notifyRefreshStarted() {
        refreshObservers.forEach({ $0.refreshServiceDidBeginRefreshing() })
    }
    
    private var longRunningTaskIdentifier: AnyHashable?
    private func startLongRunningTask() {
        longRunningTaskIdentifier = longRunningTaskManager?.beginLongRunningTask()
    }
    
    private func finishLongRunningTask() {
        if let identifier = longRunningTaskIdentifier {
            longRunningTaskManager?.finishLongRunningTask(token: identifier)
            longRunningTaskIdentifier = nil
        }
    }

}
