import ComponentBase
import RouterCore

public struct AnnouncementRoute {
    
    private let announcementModuleFactory: AnnouncementDetailComponentFactory
    private let contentWireframe: ContentWireframe
    
    public init(
        announcementModuleFactory: AnnouncementDetailComponentFactory,
        contentWireframe: ContentWireframe
    ) {
        self.announcementModuleFactory = announcementModuleFactory
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - Route

extension AnnouncementRoute: Route {
    
    public typealias Parameter = AnnouncementRouteable
    
    public func route(_ content: AnnouncementRouteable) {
        let announcementContentController = announcementModuleFactory.makeAnnouncementDetailModule(
            for: content.identifier
        )
        
        contentWireframe.replaceDetailContentController(announcementContentController)
    }
    
}
