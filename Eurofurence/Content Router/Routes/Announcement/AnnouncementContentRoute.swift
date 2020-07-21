import Foundation

public struct AnnouncementContentRoute {
    
    private let announcementModuleFactory: AnnouncementDetailComponentFactory
    private let announcementsTabNavigator: TabNavigator
    private let contentWireframe: ContentWireframe
    
    public init(
        announcementModuleFactory: AnnouncementDetailComponentFactory,
        announcementsTabNavigator: TabNavigator,
        contentWireframe: ContentWireframe
    ) {
        self.announcementModuleFactory = announcementModuleFactory
        self.announcementsTabNavigator = announcementsTabNavigator
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
        
        announcementsTabNavigator.moveToTab()
        contentWireframe.presentDetailContentController(announcementContentController)
    }
    
}
