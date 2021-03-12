import Foundation

class RefreshChain {
    
    private let first: Node
    
    init(
        conventionIdentifier: ConventionIdentifier,
        forceRefreshRequired: ForceRefreshRequired,
        dataStore: DataStore,
        api: API,
        imageDownloader: ImageDownloader,
        eventBus: EventBus,
        imageCache: ImagesCache,
        privateMessagesController: ConcretePrivateMessagesService,
        refreshCollaboration: RefreshCollaboration,
        clock: Clock,
        imageRepository: ImageRepository,
        dataStoreBridge: DataStoreSyncBridge
    ) {
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
            eventBus: eventBus,
            imageCache: imageCache,
            clock: clock,
            imageRepository: imageRepository,
            dataStoreBridge: dataStoreBridge
        )
        
        first = fetchModel
    }
    
    func start(progress: Progress, chainComplete: @escaping (RefreshServiceError?) -> Void) {
        first.start(progress: progress, chainComplete: chainComplete)
    }
    
}

// MARK: - Node

extension RefreshChain {
    
    class Node {
        
        private var next: Node?
        private var chainComplete: ((RefreshServiceError?) -> Void)?
        
        init(next: Node?) {
            self.next = next
        }
        
        func start(progress: Progress, chainComplete: ((RefreshServiceError?) -> Void)?) {
            self.chainComplete = chainComplete
        }
        
        final func finish(progress: Progress, error: RefreshServiceError?) {
            if let error = error {
                chainComplete?(error)
            } else if let next = next {
                next.start(progress: progress, chainComplete: chainComplete)
            } else {
                chainComplete?(nil)
            }
        }
        
    }
    
}
