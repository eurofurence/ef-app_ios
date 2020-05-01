import Foundation

public struct AnnouncementContentRoute {
    
    private let announcementModuleFactory: AnnouncementDetailModuleProviding
    private let contentWireframe: ContentWireframe
    
    public init(
        announcementModuleFactory: AnnouncementDetailModuleProviding,
        contentWireframe: ContentWireframe
    ) {
        self.announcementModuleFactory = announcementModuleFactory
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - ContentRoute

extension AnnouncementContentRoute: ContentRoute {
    
    public typealias Content = AnnouncementContentRepresentation
    
    public func route(_ content: AnnouncementContentRepresentation) {
        let announcementContentController = announcementModuleFactory.makeAnnouncementDetailModule(
            for: content.identifier
        )
        
        contentWireframe.presentNewsContentController(announcementContentController)
    }
    
}
