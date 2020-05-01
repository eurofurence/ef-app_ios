@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubCollectThemAllModuleProviding: CollectThemAllModuleProviding {

    let stubInterface = FakeViewController()
    func makeCollectThemAllModule() -> UIViewController {
        return stubInterface
    }

}

class StubMapsModuleProviding: MapsModuleProviding {

    let stubInterface = FakeViewController()
    private(set) var delegate: MapsModuleDelegate?
    func makeMapsModule(_ delegate: MapsModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubMapsModuleProviding {

    func simulateDidSelectMap(_ map: MapIdentifier) {
        delegate?.mapsModuleDidSelectMap(identifier: map)
    }

}

class StubMapDetailModuleProviding: MapDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedModel: MapIdentifier?
    private(set) var delegate: MapDetailModuleDelegate?
    func makeMapDetailModule(for map: MapIdentifier, delegate: MapDetailModuleDelegate) -> UIViewController {
        capturedModel = map
        self.delegate = delegate
        return stubInterface
    }

}

extension StubMapDetailModuleProviding {

    func simulateDidSelectDealer(_ dealer: DealerIdentifier) {
        delegate?.mapDetailModuleDidSelectDealer(dealer)
    }

}

class StubAnnouncementsModuleProviding: AnnouncementsModuleProviding {

    let stubInterface = UIViewController()
    private(set) var delegate: AnnouncementsModuleDelegate?
    func makeAnnouncementsModule(_ delegate: AnnouncementsModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubAnnouncementsModuleProviding {

    func simulateDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        delegate?.announcementsModuleDidSelectAnnouncement(announcement)
    }

}

class StubKnowledgeGroupEntriesModuleProviding: KnowledgeGroupEntriesModuleProviding {

    let stubInterface = UIViewController()
    private(set) var delegate: KnowledgeGroupEntriesModuleDelegate?
    private(set) var capturedModel: KnowledgeGroupIdentifier?
    func makeKnowledgeGroupEntriesModule(_ groupIdentifier: KnowledgeGroupIdentifier, delegate: KnowledgeGroupEntriesModuleDelegate) -> UIViewController {
        capturedModel = groupIdentifier
        self.delegate = delegate
        return stubInterface
    }

}

extension StubKnowledgeGroupEntriesModuleProviding {

    func simulateKnowledgeEntrySelected(_ entry: KnowledgeEntryIdentifier) {
        delegate?.knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: entry)
    }

}

class StubEventFeedbackModuleProviding: EventFeedbackModuleProviding {
    
    let stubInterface = CapturingViewController()
    private(set) var eventToLeaveFeedbackFor: EventIdentifier?
    private var delegate: EventFeedbackModuleDelegate?
    func makeEventFeedbackModule(for event: EventIdentifier, delegate: EventFeedbackModuleDelegate) -> UIViewController {
        eventToLeaveFeedbackFor = event
        self.delegate = delegate
        return stubInterface
    }
    
    func simulateDismissFeedback() {
        delegate?.eventFeedbackCancelled()
    }
    
}

class StubAdditionalServicesModuleProviding: AdditionalServicesModuleProviding {
    
    let stubInterface = UIViewController()
    func makeAdditionalServicesModule() -> UIViewController {
        return stubInterface
    }
    
}

class ApplicationDirectorTestBuilder {

    struct Context {

        var director: ApplicationDirector
        var moduleOrderingPolicy: ModuleOrderingPolicy
        var rootModule: StubRootModuleFactory
        var tutorialModule: StubTutorialModuleFactory
        var preloadModule: StubPreloadModuleFactory
        var tabModule: StubTabModuleFactory
        var newsModule: StubNewsModuleFactory
        var scheduleModule: StubScheduleModuleFactory
        var dealersModule: StubDealersModuleFactory
        var dealerDetailModule: StubDealerDetailModuleProviding
        var collectThemAllModule: StubCollectThemAllModuleProviding
        var messages: StubMessagesModuleFactory
        var loginModule: StubLoginModuleFactory
        var windowWireframe: CapturingWindowWireframe
        var messageDetailModule: StubMessageDetailModuleProviding
        var knowledgeListModule: StubKnowledgeGroupsListModuleProviding
        var knowledgeGroupEntriesModule: StubKnowledgeGroupEntriesModuleProviding
        var knowledgeDetailModule: StubKnowledgeDetailModuleProviding
        var mapsModule: StubMapsModuleProviding
        var mapDetailModule: StubMapDetailModuleProviding
        var announcementsModule: StubAnnouncementsModuleProviding
        var announcementDetailModule: StubAnnouncementDetailModuleFactory
        var eventDetailModule: StubEventDetailModuleFactory
        var eventFeedbackModule: StubEventFeedbackModuleProviding
        var additionalServicesModule: StubAdditionalServicesModuleProviding
        var linkRouter: StubContentLinksService
        var webModuleProviding: StubWebMobuleProviding
        var urlOpener: CapturingURLOpener

    }

    private var moduleOrderingPolicy: ModuleOrderingPolicy
    private let rootModule: StubRootModuleFactory
    private let tutorialModule: StubTutorialModuleFactory
    private let preloadModule: StubPreloadModuleFactory
    private let tabModule: StubTabModuleFactory
    private let newsModule: StubNewsModuleFactory
    private let scheduleModule: StubScheduleModuleFactory
    private let dealersModule: StubDealersModuleFactory
    private let dealerDetailModule: StubDealerDetailModuleProviding
    private let collectThemAllModule: StubCollectThemAllModuleProviding
    private let messagesModule: StubMessagesModuleFactory
    private let loginModule: StubLoginModuleFactory
    private let windowWireframe: CapturingWindowWireframe
    private let messageDetailModule: StubMessageDetailModuleProviding
    private let knowledgeListModule: StubKnowledgeGroupsListModuleProviding
    private let knowledgeGroupEntriesModule: StubKnowledgeGroupEntriesModuleProviding
    private let knowledgeDetailModule: StubKnowledgeDetailModuleProviding
    private let mapsModule: StubMapsModuleProviding
    private let mapDetailModule: StubMapDetailModuleProviding
    private let announcementsModule: StubAnnouncementsModuleProviding
    private let announcementDetailModule: StubAnnouncementDetailModuleFactory
    private let eventDetailModule: StubEventDetailModuleFactory
    private let eventFeedbackModule: StubEventFeedbackModuleProviding
    private let additionalServicesModule: StubAdditionalServicesModuleProviding
    private let linkRouter: StubContentLinksService
    private let webModuleProviding: StubWebMobuleProviding
    private let urlOpener: CapturingURLOpener
    
    private struct DoNotChangeOrderPolicy: ModuleOrderingPolicy {
        func order(modules: [UIViewController]) -> [UIViewController] {
            return modules
        }
        
        func saveOrder(_ modules: [UIViewController]) {
            
        }
    }

    init() {
        moduleOrderingPolicy = DoNotChangeOrderPolicy()
        rootModule = StubRootModuleFactory()
        tutorialModule = StubTutorialModuleFactory()
        preloadModule = StubPreloadModuleFactory()
        windowWireframe = CapturingWindowWireframe()
        tabModule = StubTabModuleFactory()
        newsModule = StubNewsModuleFactory()
        scheduleModule = StubScheduleModuleFactory()
        dealersModule = StubDealersModuleFactory()
        dealerDetailModule = StubDealerDetailModuleProviding()
        collectThemAllModule = StubCollectThemAllModuleProviding()
        messagesModule = StubMessagesModuleFactory()
        loginModule = StubLoginModuleFactory()
        messageDetailModule = StubMessageDetailModuleProviding()
        knowledgeListModule = StubKnowledgeGroupsListModuleProviding()
        knowledgeGroupEntriesModule = StubKnowledgeGroupEntriesModuleProviding()
        knowledgeDetailModule = StubKnowledgeDetailModuleProviding()
        mapsModule = StubMapsModuleProviding()
        mapDetailModule = StubMapDetailModuleProviding()
        announcementsModule = StubAnnouncementsModuleProviding()
        announcementDetailModule = StubAnnouncementDetailModuleFactory()
        eventDetailModule = StubEventDetailModuleFactory()
        eventFeedbackModule = StubEventFeedbackModuleProviding()
        additionalServicesModule = StubAdditionalServicesModuleProviding()
        linkRouter = StubContentLinksService()
        webModuleProviding = StubWebMobuleProviding()
        urlOpener = CapturingURLOpener()
    }
    
    @discardableResult
    func with(_ orderingPolicy: ModuleOrderingPolicy) -> ApplicationDirectorTestBuilder {
        self.moduleOrderingPolicy = orderingPolicy
        return self
    }

    func build() -> Context {
        let director = makeDirectorBuilder().build()

        return Context(director: director,
                       moduleOrderingPolicy: moduleOrderingPolicy,
                       rootModule: rootModule,
                       tutorialModule: tutorialModule,
                       preloadModule: preloadModule,
                       tabModule: tabModule,
                       newsModule: newsModule,
                       scheduleModule: scheduleModule,
                       dealersModule: dealersModule,
                       dealerDetailModule: dealerDetailModule,
                       collectThemAllModule: collectThemAllModule,
                       messages: messagesModule,
                       loginModule: loginModule,
                       windowWireframe: windowWireframe,
                       messageDetailModule: messageDetailModule,
                       knowledgeListModule: knowledgeListModule,
                       knowledgeGroupEntriesModule: knowledgeGroupEntriesModule,
                       knowledgeDetailModule: knowledgeDetailModule,
                       mapsModule: mapsModule,
                       mapDetailModule: mapDetailModule,
                       announcementsModule: announcementsModule,
                       announcementDetailModule: announcementDetailModule,
                       eventDetailModule: eventDetailModule,
                       eventFeedbackModule: eventFeedbackModule,
                       additionalServicesModule: additionalServicesModule,
                       linkRouter: linkRouter,
                       webModuleProviding: webModuleProviding,
                       urlOpener: urlOpener)
    }

    private func makeDirectorBuilder() -> DirectorBuilder {
        let moduleRepository = FakeModuleRepository(webModuleProviding: webModuleProviding,
                                                    rootModuleProviding: rootModule,
                                                    tutorialModuleProviding: tutorialModule,
                                                    preloadModuleProviding: preloadModule,
                                                    newsModuleProviding: newsModule,
                                                    scheduleModuleProviding: scheduleModule,
                                                    dealersModuleProviding: dealersModule,
                                                    dealerDetailModuleProviding: dealerDetailModule,
                                                    collectThemAllModuleProviding: collectThemAllModule,
                                                    messagesModuleProviding: messagesModule,
                                                    loginModuleProviding: loginModule,
                                                    messageDetailModuleProviding: messageDetailModule,
                                                    knowledgeListModuleProviding: knowledgeListModule,
                                                    knowledgeGroupEntriesModule: knowledgeGroupEntriesModule,
                                                    knowledgeDetailModuleProviding: knowledgeDetailModule,
                                                    mapsModuleProviding: mapsModule,
                                                    mapDetailModuleProviding: mapDetailModule,
                                                    announcementsModuleFactory: announcementsModule,
                                                    announcementDetailModuleProviding: announcementDetailModule,
                                                    eventDetailModuleProviding: eventDetailModule,
                                                    eventFeedbackModuleProviding: eventFeedbackModule,
                                                    additionalServicesModule: additionalServicesModule)
        
        let builder = DirectorBuilder(moduleRepository: moduleRepository, linkLookupService: linkRouter)
        builder.withAnimations(false)
        builder.with(moduleOrderingPolicy)
        builder.with(windowWireframe)
        builder.with(StubNavigationControllerFactory())
        builder.with(tabModule)
        builder.with(urlOpener)

        return builder
    }

}

extension ApplicationDirectorTestBuilder.Context {

    func navigateToTabController() {
        rootModule.simulateStoreShouldBeRefreshed()
        preloadModule.simulatePreloadFinished()
    }

    func navigationController(for viewController: UIViewController) -> CapturingNavigationController? {
        return tabModule.navigationController(for: viewController)
    }

}
