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
        privateMessagesController: ConcretePrivateMessagesService,
        forceRefreshRequired: ForceRefreshRequired,
        refreshCollaboration: RefreshCollaboration,
        dataStoreBridge: DataStoreSyncBridge
    ) {
        self.longRunningTaskManager = longRunningTaskManager
        
        chain = RefreshChain(
            conventionIdentifier: conventionIdentifier,
            forceRefreshRequired: forceRefreshRequired,
            dataStore: dataStore,
            api: api,
            imageDownloader: imageDownloader,
            privateMessagesController: privateMessagesController,
            refreshCollaboration: refreshCollaboration,
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
