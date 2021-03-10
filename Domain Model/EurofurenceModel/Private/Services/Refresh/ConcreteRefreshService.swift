import Foundation

class ConcreteRefreshService: RefreshService {
    
    private let privateMessagesController: ConcretePrivateMessagesService

    private let conventionIdentifier: ConventionIdentifier
    private let longRunningTaskManager: LongRunningTaskManager?
    private let dataStore: DataStore
    private let api: API
    private let imageDownloader: ImageDownloader
    private let clock: Clock
    private let eventBus: EventBus
    private let imageCache: ImagesCache
    private let imageRepository: ImageRepository
    private let forceRefreshRequired: ForceRefreshRequired
    private let refreshCollaboration: RefreshCollaboration
    
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
        self.conventionIdentifier = conventionIdentifier
        self.longRunningTaskManager = longRunningTaskManager
        self.dataStore = dataStore
        self.api = api
        self.imageDownloader = imageDownloader
        self.clock = clock
        self.eventBus = eventBus
        self.imageCache = imageCache
        self.imageRepository = imageRepository
        self.privateMessagesController = privateMessagesController
        self.forceRefreshRequired = forceRefreshRequired
        self.refreshCollaboration = refreshCollaboration
        
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
            imageRepository: imageRepository
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
