import ComponentBase
import RouterCore

public struct AnnouncementsRoute {
    
    private let announcementsComponentFactory: AnnouncementsComponentFactory
    private let contentWireframe: ContentWireframe
    private let delegate: AnnouncementsComponentDelegate
    
    public init(
        announcementsComponentFactory: AnnouncementsComponentFactory,
        contentWireframe: ContentWireframe,
        delegate: AnnouncementsComponentDelegate
    ) {
        self.announcementsComponentFactory = announcementsComponentFactory
        self.contentWireframe = contentWireframe
        self.delegate = delegate
    }
    
}

// MARK: - 

extension AnnouncementsRoute: Route {
    
    public typealias Parameter = AnnouncementsRouteable
    
    public func route(_ content: AnnouncementsRouteable) {
        let contentController = announcementsComponentFactory.makeAnnouncementsComponent(delegate)
        contentWireframe.presentPrimaryContentController(contentController)
    }
    
}
