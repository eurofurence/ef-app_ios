//
//  MessagesModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation.NSDateFormatter

class MessagesModuleBuilder {

    private var sceneFactory: MessagesSceneFactory
    private var authService: AuthService
    private var privateMessagesService: PrivateMessagesService
    private var dateFormatter: DateFormatterProtocol

    init() {
        sceneFactory = PhoneMessagesSceneFactory()
        authService = EurofurenceAuthService(app: EurofurenceApplication.shared)
        privateMessagesService = EurofurencePrivateMessagesService(app: EurofurenceApplication.shared)
        dateFormatter = DateFormatter()
    }

    func with(_ sceneFactory: MessagesSceneFactory) -> MessagesModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func with(_ authService: AuthService) -> MessagesModuleBuilder {
        self.authService = authService
        return self
    }

    func with(_ privateMessagesService: PrivateMessagesService) ->
        MessagesModuleBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }

    func with(_ dateFormatter: DateFormatterProtocol) -> MessagesModuleBuilder {
        self.dateFormatter = dateFormatter
        return self
    }

    func build() -> MessagesModuleProviding {
        return PhoneMessagesModuleFactory(sceneFactory: sceneFactory,
                                          authService: authService,
                                          privateMessagesService: privateMessagesService,
                                          dateFormatter: dateFormatter)
    }

}
