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
    private var messagesModuleProviding: MessagesModuleProviding
    private var loginModuleProviding: LoginModuleProviding
    private var messageDetailModuleProviding: MessageDetailModuleProviding
    private var knowledgeListModuleProviding: KnowledgeListModuleProviding
    private var knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding

    init() {
        animate = true
        windowWireframe = PhoneWindowWireframe.shared
        navigationControllerFactory = PhoneNavigationControllerFactory()
        tabModuleProviding = PhoneTabModuleFactory()

        rootModuleProviding = RootModuleBuilder().build()
        tutorialModuleProviding = TutorialModuleBuilder().build()
        preloadModuleProviding = PreloadModuleBuilder().build()
        newsModuleProviding = NewsModuleBuilder().build()
        messagesModuleProviding = MessagesModuleBuilder().build()
        loginModuleProviding = LoginModuleBuilder().build()
        messageDetailModuleProviding = MessageDetailModuleBuilder().build()
        knowledgeListModuleProviding = KnowledgeListModuleBuilder().build()
        knowledgeDetailModuleProviding = KnowledgeDetailModuleBuilder().build()

        struct DummyLinkLookupService: LinkLookupService {
            func lookupContent(for link: Link) -> LinkContentLookupResult? {
                return nil
            }
        }

        linkLookupService = DummyLinkLookupService()
        webModuleProviding = SafariWebModuleProviding()
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
    func with(_ webModuleProviding: WebModuleProviding) -> DirectorBuilder {
        self.webModuleProviding = webModuleProviding
        return self
    }

    func build() -> ApplicationDirector {
        return ApplicationDirector(animate: animate,
                                   linkLookupService: linkLookupService,
                                   webModuleProviding: webModuleProviding,
                                   windowWireframe: windowWireframe,
                                   navigationControllerFactory: navigationControllerFactory,
                                   rootModuleProviding: rootModuleProviding,
                                   tutorialModuleProviding: tutorialModuleProviding,
                                   preloadModuleProviding: preloadModuleProviding,
                                   tabModuleProviding: tabModuleProviding,
                                   newsModuleProviding: newsModuleProviding,
                                   messagesModuleProviding: messagesModuleProviding,
                                   loginModuleProviding: loginModuleProviding,
                                   messageDetailModuleProviding: messageDetailModuleProviding,
                                   knowledgeListModuleProviding: knowledgeListModuleProviding,
                                   knowledgeDetailModuleProviding: knowledgeDetailModuleProviding)
    }

}
