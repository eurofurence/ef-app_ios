import EurofurenceComponentBase
import Foundation

public struct AnnouncementContentRoute {
    
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

// MARK: - ContentRoute

extension AnnouncementContentRoute: ContentRoute {
    
    public typealias Content = AnnouncementContentRepresentation
    
    public func route(_ content: AnnouncementContentRepresentation) {
        let announcementContentController = announcementModuleFactory.makeAnnouncementDetailModule(
            for: content.identifier
        )
        
        contentWireframe.replaceDetailContentController(announcementContentController)
    }
    
}
