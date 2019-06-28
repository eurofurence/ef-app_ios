@testable import Eurofurence
import EurofurenceModel
import UIKit

struct FakeModuleRepository: ModuleRepository {
    
    var webModuleProviding: WebModuleProviding
    var rootModuleProviding: RootModuleProviding
    var tutorialModuleProviding: TutorialModuleProviding
    var preloadModuleProviding: PreloadModuleProviding
    var newsModuleProviding: NewsModuleProviding
    var scheduleModuleProviding: ScheduleModuleProviding
    var dealersModuleProviding: DealersModuleProviding
    var dealerDetailModuleProviding: DealerDetailModuleProviding
    var collectThemAllModuleProviding: CollectThemAllModuleProviding
    var messagesModuleProviding: MessagesModuleProviding
    var loginModuleProviding: LoginModuleProviding
    var messageDetailModuleProviding: MessageDetailModuleProviding
    var knowledgeListModuleProviding: KnowledgeGroupsListModuleProviding
    var knowledgeGroupEntriesModule: KnowledgeGroupEntriesModuleProviding
    var knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding
    var mapsModuleProviding: MapsModuleProviding
    var mapDetailModuleProviding: MapDetailModuleProviding
    var announcementsModuleFactory: AnnouncementsModuleProviding
    var announcementDetailModuleProviding: AnnouncementDetailModuleProviding
    var eventDetailModuleProviding: EventDetailModuleProviding
    var eventFeedbackModuleProviding: EventFeedbackModuleProviding
    var additionalServicesModule: AdditionalServicesModuleProviding
    
    func makeRootModule(_ delegate: RootModuleDelegate) {
        rootModuleProviding.makeRootModule(delegate)
    }
    
    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        return tutorialModuleProviding.makeTutorialModule(delegate)
    }
    
    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        return preloadModuleProviding.makePreloadModule(delegate)
    }
    
    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        return newsModuleProviding.makeNewsModule(delegate)
    }
    
    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        return loginModuleProviding.makeLoginModule(delegate)
    }
    
    func makeAnnouncementsModule(_ delegate: AnnouncementsModuleDelegate) -> UIViewController {
        return announcementsModuleFactory.makeAnnouncementsModule(delegate)
    }
    
    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController {
        return announcementDetailModuleProviding.makeAnnouncementDetailModule(for: announcement)
    }
    
    func makeEventDetailModule(for event: EventIdentifier, delegate: EventDetailModuleDelegate) -> UIViewController {
        return eventDetailModuleProviding.makeEventDetailModule(for: event, delegate: delegate)
    }
    
    func makeEventFeedbackModule(for event: EventIdentifier, delegate: EventFeedbackModuleDelegate) -> UIViewController {
        return eventFeedbackModuleProviding.makeEventFeedbackModule(for: event, delegate: delegate)
    }
    
    func makeWebModule(for url: URL) -> UIViewController {
        return webModuleProviding.makeWebModule(for: url)
    }
    
    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        return messagesModuleProviding.makeMessagesModule(delegate)
    }
    
    func makeMessageDetailModule(message: MessageIdentifier) -> UIViewController {
        return messageDetailModuleProviding.makeMessageDetailModule(for: message)
    }
    
    func makeScheduleModule(_ delegate: ScheduleModuleDelegate) -> UIViewController {
        return scheduleModuleProviding.makeScheduleModule(delegate)
    }
    
    func makeDealersModule(_ delegate: DealersModuleDelegate) -> UIViewController {
        return dealersModuleProviding.makeDealersModule(delegate)
    }
    
    func makeDealerDetailModule(for identifier: DealerIdentifier) -> UIViewController {
        return dealerDetailModuleProviding.makeDealerDetailModule(for: identifier)
    }
    
    func makeKnowledgeListModule(_ delegate: KnowledgeGroupsListModuleDelegate) -> UIViewController {
        return knowledgeListModuleProviding.makeKnowledgeListModule(delegate)
    }
    
    func makeKnowledgeDetailModule(_ identifier: KnowledgeEntryIdentifier, delegate: KnowledgeDetailModuleDelegate) -> UIViewController {
        return knowledgeDetailModuleProviding.makeKnowledgeListModule(identifier, delegate: delegate)
    }
    
    func makeKnowledgeGroupEntriesModule(_ knowledgeGroup: KnowledgeGroupIdentifier, delegate: KnowledgeGroupEntriesModuleDelegate) -> UIViewController {
        return knowledgeGroupEntriesModule.makeKnowledgeGroupEntriesModule(knowledgeGroup, delegate: delegate)
    }
    
    func makeMapsModule(_ delegate: MapsModuleDelegate) -> UIViewController {
        return mapsModuleProviding.makeMapsModule(delegate)
    }
    
    func makeMapDetailModule(for identifier: MapIdentifier, delegate: MapDetailModuleDelegate) -> UIViewController {
        return mapDetailModuleProviding.makeMapDetailModule(for: identifier, delegate: delegate)
    }
    
    func makeCollectThemAllModule() -> UIViewController {
        return collectThemAllModuleProviding.makeCollectThemAllModule()
    }
    
    func makeAdditionalServicesModule() -> UIViewController {
        return additionalServicesModule.makeAdditionalServicesModule()
    }
    
}
