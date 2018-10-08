//
//  ApplicationDirectorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
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
    
    func simulateDidSelectMap(_ map: Map2.Identifier) {
        delegate?.mapsModuleDidSelectMap(identifier: map)
    }
    
}

class StubMapDetailModuleProviding: MapDetailModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var capturedModel: Map2.Identifier?
    private(set) var delegate: MapDetailModuleDelegate?
    func makeMapDetailModule(for map: Map2.Identifier, delegate: MapDetailModuleDelegate) -> UIViewController {
        capturedModel = map
        self.delegate = delegate
        return stubInterface
    }
    
}

extension StubMapDetailModuleProviding {
    
    func simulateDidSelectDealer(_ dealer: Dealer2.Identifier) {
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
    
    func simulateDidSelectAnnouncement(_ announcement: Announcement2.Identifier) {
        delegate?.announcementsModuleDidSelectAnnouncement(announcement)
    }
    
}

class StubKnowledgeGroupEntriesModuleProviding: KnowledgeGroupEntriesModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: KnowledgeGroupEntriesModuleDelegate?
    private(set) var capturedModel: KnowledgeGroup2.Identifier?
    func makeKnowledgeGroupEntriesModule(_ groupIdentifier: KnowledgeGroup2.Identifier, delegate: KnowledgeGroupEntriesModuleDelegate) -> UIViewController {
        capturedModel = groupIdentifier
        self.delegate = delegate
        return stubInterface
    }
    
}

extension StubKnowledgeGroupEntriesModuleProviding {
    
    func simulateKnowledgeEntrySelected(_ entry: KnowledgeEntry2.Identifier) {
        delegate?.knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: entry)
    }
    
}

class ApplicationDirectorTestBuilder {
    
    struct Context {
        
        var director: ApplicationDirector
        var moduleOrderingPolicy: FakeModuleOrderingPolicy
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
        var linkRouter: StubLinkRouter
        var webModuleProviding: StubWebMobuleProviding
        var urlOpener: CapturingURLOpener
        var notificationHandling: FakeApplicationNotificationHandling
        
    }
    
    private let moduleOrderingPolicy: FakeModuleOrderingPolicy
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
    private let linkRouter: StubLinkRouter
    private let webModuleProviding: StubWebMobuleProviding
    private let urlOpener: CapturingURLOpener
    
    init() {
        moduleOrderingPolicy = FakeModuleOrderingPolicy()
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
        linkRouter = StubLinkRouter()
        webModuleProviding = StubWebMobuleProviding()
        urlOpener = CapturingURLOpener()
    }
    
    func build() -> Context {
        let notificationHandling = FakeApplicationNotificationHandling()
        
        let builder = DirectorBuilder()
        builder.withAnimations(false)
        builder.with(moduleOrderingPolicy)
        builder.with(windowWireframe)
        builder.with(StubNavigationControllerFactory())
        builder.with(rootModule)
        builder.with(tutorialModule)
        builder.with(preloadModule)
        builder.with(tabModule)
        builder.with(newsModule)
        builder.with(scheduleModule)
        builder.with(dealersModule)
        builder.with(dealerDetailModule)
        builder.with(collectThemAllModule)
        builder.with(messagesModule)
        builder.with(loginModule)
        builder.with(messageDetailModule)
        builder.with(knowledgeListModule)
        builder.with(knowledgeGroupEntriesModule)
        builder.with(knowledgeDetailModule)
        builder.with(mapsModule)
        builder.with(mapDetailModule)
        builder.with(announcementsModule)
        builder.with(announcementDetailModule)
        builder.with(eventDetailModule)
        builder.with(linkRouter)
        builder.with(webModuleProviding)
        builder.with(urlOpener)
        builder.with(notificationHandling)
        
        let director = builder.build()
        
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
                       linkRouter: linkRouter,
                       webModuleProviding: webModuleProviding,
                       urlOpener: urlOpener,
                       notificationHandling: notificationHandling)
    }
    
}

extension ApplicationDirectorTestBuilder.Context {
    
    func navigateToTabController() {
        rootModule.simulateStoreShouldBeRefreshed()
        preloadModule.simulatePreloadFinished()
    }
    
    var rootNavigationController: UINavigationController {
        return windowWireframe.capturedRootInterface as! UINavigationController
    }
    
    func navigationController(for viewController: UIViewController) -> CapturingNavigationController? {
        return tabModule.navigationController(for: viewController)
    }
    
}
