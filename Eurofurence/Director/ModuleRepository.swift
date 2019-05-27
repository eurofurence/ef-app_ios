import EurofurenceModel
import UIKit

protocol ModuleRepository {
    
    func makeRootModule(_ delegate: RootModuleDelegate)
    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController
    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController
    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController
    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController
    func makeAnnouncementsModule(_ delegate: AnnouncementsModuleDelegate) -> UIViewController
    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController
    func makeEventDetailModule(for event: EventIdentifier, delegate: EventDetailModuleDelegate) -> UIViewController
    func makeEventFeedbackModule(for event: EventIdentifier, delegate: EventFeedbackModuleDelegate) -> UIViewController
    func makeWebModule(for url: URL) -> UIViewController
    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController
    func makeMessageDetailModule(message: Message) -> UIViewController
    func makeScheduleModule(_ delegate: ScheduleModuleDelegate) -> UIViewController
    func makeDealersModule(_ delegate: DealersModuleDelegate) -> UIViewController
    func makeDealerDetailModule(for identifier: DealerIdentifier) -> UIViewController
    func makeKnowledgeListModule(_ delegate: KnowledgeGroupsListModuleDelegate) -> UIViewController
    func makeKnowledgeDetailModule(_ identifier: KnowledgeEntryIdentifier, delegate: KnowledgeDetailModuleDelegate) -> UIViewController
    func makeKnowledgeGroupEntriesModule(_ knowledgeGroup: KnowledgeGroupIdentifier, delegate: KnowledgeGroupEntriesModuleDelegate) -> UIViewController
    func makeMapsModule(_ delegate: MapsModuleDelegate) -> UIViewController
    func makeMapDetailModule(for identifier: MapIdentifier, delegate: MapDetailModuleDelegate) -> UIViewController
    func makeCollectThemAllModule() -> UIViewController
    
}
