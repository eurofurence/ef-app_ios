//
//  ApplicationDirectorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubCollectThemAllModuleProviding: CollectThemAllModuleProviding {
    
    let stubInterface = UIViewController()
    func makeCollectThemAllModule() -> UIViewController {
        return stubInterface
    }
    
}

class ApplicationDirectorTestBuilder {
    
    struct Context {
        
        var director: ApplicationDirector
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
        var knowledgeListModule: StubKnowledgeListModuleProviding
        var knowledgeDetailModule: StubKnowledgeDetailModuleProviding
        var announcementDetailModule: StubAnnouncementDetailModuleFactory
        var eventDetailModule: StubEventDetailModuleFactory
        var linkRouter: StubLinkRouter
        var webModuleProviding: StubWebMobuleProviding
        var urlOpener: CapturingURLOpener
        
    }
    
    private let director: ApplicationDirector
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
    private let knowledgeListModule: StubKnowledgeListModuleProviding
    private let knowledgeDetailModule: StubKnowledgeDetailModuleProviding
    private let announcementDetailModule: StubAnnouncementDetailModuleFactory
    private let eventDetailModule: StubEventDetailModuleFactory
    private let linkRouter: StubLinkRouter
    private let webModuleProviding: StubWebMobuleProviding
    private let urlOpener: CapturingURLOpener
    
    init() {
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
        knowledgeListModule = StubKnowledgeListModuleProviding()
        knowledgeDetailModule = StubKnowledgeDetailModuleProviding()
        announcementDetailModule = StubAnnouncementDetailModuleFactory()
        eventDetailModule = StubEventDetailModuleFactory()
        linkRouter = StubLinkRouter()
        webModuleProviding = StubWebMobuleProviding()
        urlOpener = CapturingURLOpener()
        
        let builder = DirectorBuilder()
        builder.withAnimations(false)
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
        builder.with(knowledgeDetailModule)
        builder.with(announcementDetailModule)
        builder.with(eventDetailModule)
        builder.with(linkRouter)
        builder.with(webModuleProviding)
        builder.with(urlOpener)
        
        director = builder.build()
    }
    
    func build() -> Context {
        return Context(director: director,
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
                       knowledgeDetailModule: knowledgeDetailModule,
                       announcementDetailModule: announcementDetailModule,
                       eventDetailModule: eventDetailModule,
                       linkRouter: linkRouter,
                       webModuleProviding: webModuleProviding,
                       urlOpener: urlOpener)
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
