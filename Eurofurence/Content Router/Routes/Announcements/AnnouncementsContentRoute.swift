import Foundation

public struct AnnouncementsContentRoute {
    
    private let announcementsModuleProviding: AnnouncementsModuleProviding
    private let contentWireframe: ContentWireframe
    private let delegate: AnnouncementsModuleDelegate
    
    public init(
        announcementsModuleProviding: AnnouncementsModuleProviding,
        contentWireframe: ContentWireframe,
        delegate: AnnouncementsModuleDelegate
    ) {
        self.announcementsModuleProviding = announcementsModuleProviding
        self.contentWireframe = contentWireframe
        self.delegate = delegate
    }
    
}

// MARK: - 

extension AnnouncementsContentRoute: ContentRoute {
    
    public typealias Content = AnnouncementsContentRepresentation
    
    public func route(_ content: AnnouncementsContentRepresentation) {
        let contentController = announcementsModuleProviding.makeAnnouncementsModule(delegate)
        contentWireframe.presentMasterContentController(contentController)
    }
    
}
