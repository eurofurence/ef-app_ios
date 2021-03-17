import ComponentBase
import Foundation

public struct AnnouncementsContentRoute {
    
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

extension AnnouncementsContentRoute: ContentRoute {
    
    public typealias Content = AnnouncementsContentRepresentation
    
    public func route(_ content: AnnouncementsContentRepresentation) {
        let contentController = announcementsComponentFactory.makeAnnouncementsComponent(delegate)
        contentWireframe.presentPrimaryContentController(contentController)
    }
    
}
