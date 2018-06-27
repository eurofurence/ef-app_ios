//
//  DirectorBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 05/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class DirectorBuilder {

    private var animate: Bool
    private var linkLookupService: LinkLookupService
    private var webModuleProviding: WebModuleProviding
    private var windowWireframe: WindowWireframe
    private var navigationControllerFactory: NavigationControllerFactory
    private var rootModuleProviding: RootModuleProviding
    private var tutorialModuleProviding: TutorialModuleProviding
    private var preloadModuleProviding: PreloadModuleProviding
    private var tabModuleProviding: TabModuleProviding
    private var newsModuleProviding: NewsModuleProviding
    private var scheduleModuleProviding: ScheduleModuleProviding
    private var dealersModuleProviding: DealersModuleProviding
    private var dealerDetailModuleProviding: DealerDetailModuleProviding
    private var collectThemAllModuleProviding: CollectThemAllModuleProviding
    private var messagesModuleProviding: MessagesModuleProviding
    private var loginModuleProviding: LoginModuleProviding
    private var messageDetailModuleProviding: MessageDetailModuleProviding
    private var knowledgeListModuleProviding: KnowledgeListModuleProviding
    private var knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding
    private var mapsModuleProviding: MapsModuleProviding
    private var mapDetailModuleProviding: MapDetailModuleProviding
    private var announcementDetailModuleProviding: AnnouncementDetailModuleProviding
    private var eventDetailModuleProviding: EventDetailModuleProviding
    private var urlOpener: URLOpener

    init() {
        animate = true
        windowWireframe = PhoneWindowWireframe.shared
        navigationControllerFactory = PhoneNavigationControllerFactory()
        tabModuleProviding = PhoneTabModuleFactory()

        rootModuleProviding = RootModuleBuilder().build()
        tutorialModuleProviding = TutorialModuleBuilder().build()
        preloadModuleProviding = PreloadModuleBuilder().build()
        newsModuleProviding = NewsModuleBuilder().build()
        scheduleModuleProviding = ScheduleModuleBuilder().build()
        dealersModuleProviding = DealersModuleBuilder().build()
        dealerDetailModuleProviding = DealerDetailModuleBuilder().build()
        collectThemAllModuleProviding = CollectThemAllModuleBuilder().build()
        messagesModuleProviding = MessagesModuleBuilder().build()
        loginModuleProviding = LoginModuleBuilder().build()
        messageDetailModuleProviding = MessageDetailModuleBuilder().build()
        knowledgeListModuleProviding = KnowledgeListModuleBuilder().build()
        knowledgeDetailModuleProviding = KnowledgeDetailModuleBuilder().build()
        mapsModuleProviding = MapsModuleBuilder().build()
        mapDetailModuleProviding = MapDetailModuleBuilder().build()
        announcementDetailModuleProviding = AnnouncementDetailModuleBuilder().build()
        eventDetailModuleProviding = EventDetailModuleBuilder().build()

        linkLookupService = EurofurenceApplication.shared
        webModuleProviding = SafariWebModuleProviding()
        urlOpener = AppURLOpener()
    }

    @discardableResult
    func with(_ linkLookupService: LinkLookupService) -> DirectorBuilder {
        self.linkLookupService = linkLookupService
        return self
    }

    @discardableResult
    func withAnimations(_ animate: Bool) -> DirectorBuilder {
        self.animate = animate
        return self
    }

    @discardableResult
    func with(_ windowWireframe: WindowWireframe) -> DirectorBuilder {
        self.windowWireframe = windowWireframe
        return self
    }

    @discardableResult
    func with(_ navigationControllerFactory: NavigationControllerFactory) -> DirectorBuilder {
        self.navigationControllerFactory = navigationControllerFactory
        return self
    }

    @discardableResult
    func with(_ rootModuleProviding: RootModuleProviding) -> DirectorBuilder {
        self.rootModuleProviding = rootModuleProviding
        return self
    }

    @discardableResult
    func with(_ tutorialModuleProviding: TutorialModuleProviding) -> DirectorBuilder {
        self.tutorialModuleProviding = tutorialModuleProviding
        return self
    }

    @discardableResult
    func with(_ preloadModuleProviding: PreloadModuleProviding) -> DirectorBuilder {
        self.preloadModuleProviding = preloadModuleProviding
        return self
    }

    @discardableResult
    func with(_ tabModuleProviding: TabModuleProviding) -> DirectorBuilder {
        self.tabModuleProviding = tabModuleProviding
        return self
    }

    @discardableResult
    func with(_ newsModuleProviding: NewsModuleProviding) -> DirectorBuilder {
        self.newsModuleProviding = newsModuleProviding
        return self
    }

    @discardableResult
    func with(_ scheduleModuleProviding: ScheduleModuleProviding) -> DirectorBuilder {
        self.scheduleModuleProviding = scheduleModuleProviding
        return self
    }

    @discardableResult
    func with(_ dealersModuleProviding: DealersModuleProviding) -> DirectorBuilder {
        self.dealersModuleProviding = dealersModuleProviding
        return self
    }

    @discardableResult
    func with(_ dealerDetailModuleProviding: DealerDetailModuleProviding) -> DirectorBuilder {
        self.dealerDetailModuleProviding = dealerDetailModuleProviding
        return self
    }

    @discardableResult
    func with(_ collectThemAllModuleProviding: CollectThemAllModuleProviding) -> DirectorBuilder {
        self.collectThemAllModuleProviding = collectThemAllModuleProviding
        return self
    }

    @discardableResult
    func with(_ messagesModuleProviding: MessagesModuleProviding) -> DirectorBuilder {
        self.messagesModuleProviding = messagesModuleProviding
        return self
    }

    @discardableResult
    func with(_ loginModuleProviding: LoginModuleProviding) -> DirectorBuilder {
        self.loginModuleProviding = loginModuleProviding
        return self
    }

    @discardableResult
    func with(_ messageDetailModuleProviding: MessageDetailModuleProviding) -> DirectorBuilder {
        self.messageDetailModuleProviding = messageDetailModuleProviding
        return self
    }

    @discardableResult
    func with(_ knowledgeListModuleProviding: KnowledgeListModuleProviding) -> DirectorBuilder {
        self.knowledgeListModuleProviding = knowledgeListModuleProviding
        return self
    }

    @discardableResult
    func with(_ knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding) -> DirectorBuilder {
        self.knowledgeDetailModuleProviding = knowledgeDetailModuleProviding
        return self
    }

    @discardableResult
    func with(_ mapsModuleProviding: MapsModuleProviding) -> DirectorBuilder {
        self.mapsModuleProviding = mapsModuleProviding
        return self
    }

    @discardableResult
    func with(_ mapDetailModule: MapDetailModuleProviding) -> DirectorBuilder {
        self.mapDetailModuleProviding = mapDetailModule
        return self
    }

    @discardableResult
    func with(_ announcementDetailModuleProviding: AnnouncementDetailModuleProviding) -> DirectorBuilder {
        self.announcementDetailModuleProviding = announcementDetailModuleProviding
        return self
    }

    @discardableResult
    func with(_ webModuleProviding: WebModuleProviding) -> DirectorBuilder {
        self.webModuleProviding = webModuleProviding
        return self
    }

    @discardableResult
    func with(_ urlOpener: URLOpener) -> DirectorBuilder {
        self.urlOpener = urlOpener
        return self
    }

    @discardableResult
    func with(_ eventDetailModuleProviding: EventDetailModuleProviding) -> DirectorBuilder {
        self.eventDetailModuleProviding = eventDetailModuleProviding
        return self
    }

    func build() -> ApplicationDirector {
        return ApplicationDirector(animate: animate,
                                   linkLookupService: linkLookupService,
                                   urlOpener: urlOpener,
                                   webModuleProviding: webModuleProviding,
                                   windowWireframe: windowWireframe,
                                   navigationControllerFactory: navigationControllerFactory,
                                   rootModuleProviding: rootModuleProviding,
                                   tutorialModuleProviding: tutorialModuleProviding,
                                   preloadModuleProviding: preloadModuleProviding,
                                   tabModuleProviding: tabModuleProviding,
                                   newsModuleProviding: newsModuleProviding,
                                   scheduleModuleProviding: scheduleModuleProviding,
                                   dealersModuleProviding: dealersModuleProviding,
                                   dealerDetailModuleProviding: dealerDetailModuleProviding,
                                   collectThemAllModuleProviding: collectThemAllModuleProviding,
                                   messagesModuleProviding: messagesModuleProviding,
                                   loginModuleProviding: loginModuleProviding,
                                   messageDetailModuleProviding: messageDetailModuleProviding,
                                   knowledgeListModuleProviding: knowledgeListModuleProviding,
                                   knowledgeDetailModuleProviding: knowledgeDetailModuleProviding,
                                   mapsModuleProviding: mapsModuleProviding,
                                   mapDetailModuleProviding: mapDetailModuleProviding,
                                   announcementDetailModuleProviding: announcementDetailModuleProviding,
                                   eventDetailModuleProviding: eventDetailModuleProviding)
    }

}
