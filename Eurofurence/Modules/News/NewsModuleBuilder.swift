//
//  NewsModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class NewsModuleBuilder {

    private var newsSceneFactory: NewsSceneFactory
    private var authenticationService: AuthenticationService
    private var privateMessagesService: PrivateMessagesService
    private var newsInteractor: NewsInteractor

    init() {
        struct DummyNewsInteractor: NewsInteractor {
            func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate) {

            }
        }

        newsSceneFactory = PhoneNewsSceneFactory()
        authenticationService = ApplicationAuthenticationService.shared
        privateMessagesService = EurofurencePrivateMessagesService.shared
        newsInteractor = DummyNewsInteractor()
    }

    func with(_ newsSceneFactory: NewsSceneFactory) -> NewsModuleBuilder {
        self.newsSceneFactory = newsSceneFactory
        return self
    }

    func with(_ authenticationService: AuthenticationService) -> NewsModuleBuilder {
        self.authenticationService = authenticationService
        return self
    }

    func with(_ privateMessagesService: PrivateMessagesService) -> NewsModuleBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }

    func with(_ newsInteractor: NewsInteractor) -> NewsModuleBuilder {
        self.newsInteractor = newsInteractor
        return self
    }

    func build() -> NewsModuleProviding {
        return PhoneNewsModuleFactory(newsSceneFactory: newsSceneFactory,
                                      newsInteractor: newsInteractor,
                                      authenticationService: authenticationService,
                                      privateMessagesService: privateMessagesService)
    }

}
