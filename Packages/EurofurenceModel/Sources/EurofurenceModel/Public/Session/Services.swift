import Foundation

public struct Services {

    public var notifications: NotificationService
    public var refresh: RefreshService
    public var announcements: AnnouncementsRepository
    public var authentication: AuthenticationService
    public var events: ScheduleRepository
    public var dealers: DealersService
    public var knowledge: KnowledgeService
    public var contentLinks: ContentLinksService
    public var conventionCountdown: ConventionCountdownService
    public var collectThemAll: CollectThemAllService
    public var maps: MapsService
    public var sessionState: SessionStateService
    public var privateMessages: PrivateMessagesService

}
