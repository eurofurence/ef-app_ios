//
//  NewsModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class NewsModuleBuilder {

    private var newsSceneFactory: NewsSceneFactory
    private var authService: AuthService
    private var privateMessagesService: PrivateMessagesService
    private var welcomePromptStringFactory: WelcomePromptStringFactory

    init() {
        newsSceneFactory = PhoneNewsSceneFactory()
        authService = EurofurenceAuthService.shared
        privateMessagesService = EurofurencePrivateMessagesService.shared
        welcomePromptStringFactory = UnlocalizedWelcomePromptStringFactory()
    }

    func with(_ newsSceneFactory: NewsSceneFactory) -> NewsModuleBuilder {
        self.newsSceneFactory = newsSceneFactory
        return self
    }

    func with(_ authService: AuthService) -> NewsModuleBuilder {
        self.authService = authService
        return self
    }

    func with(_ privateMessagesService: PrivateMessagesService) -> NewsModuleBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }

    func with(_ welcomePromptStringFactory: WelcomePromptStringFactory) -> NewsModuleBuilder {
        self.welcomePromptStringFactory = welcomePromptStringFactory
        return self
    }

    func build() -> NewsModuleProviding {
        return PhoneNewsModuleFactory(newsSceneFactory: newsSceneFactory,
                                      authService: authService,
                                      privateMessagesService: privateMessagesService,
                                      welcomePromptStringFactory: welcomePromptStringFactory)
    }

}
