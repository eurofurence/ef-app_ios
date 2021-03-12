import Foundation

class ConcreteRefreshService: RefreshService {
    
    private let longRunningTaskManager: LongRunningTaskManager?
    private let chainRoot: RefreshChain.Node

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
        
        let executeCollaboration = ExecuteRefreshCollaboration(
            next: nil,
            refreshCollaboration: refreshCollaboration
        )
        
        let fetchMessages = FetchPrivateMessages(
            next: executeCollaboration,
            privateMessagesController: privateMessagesController
        )
        
        let fetchModel = FetchRemoteModelAndImages(
            next: fetchMessages,
            conventionIdentifier: conventionIdentifier,
            forceRefreshRequired: forceRefreshRequired,
            dataStore: dataStore,
            api: api,
            imageDownloader: imageDownloader,
            dataStoreBridge: dataStoreBridge
        )
        
        chainRoot = fetchModel
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
        
        chainRoot.start(progress: progress) { [weak self] (error) in
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
