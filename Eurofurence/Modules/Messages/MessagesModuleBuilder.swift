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
    private var authenticationService: AuthenticationService
    private var privateMessagesService: PrivateMessagesService
    private var dateFormatter: DateFormatterProtocol
    private var presentationStrings: PresentationStrings

    init() {
        sceneFactory = PhoneMessagesSceneFactory()
        authenticationService = ApplicationAuthenticationService.shared
        privateMessagesService = EurofurencePrivateMessagesService.shared
        dateFormatter = DateFormatter()
        presentationStrings = UnlocalizedPresentationStrings()
    }

    func with(_ sceneFactory: MessagesSceneFactory) -> MessagesModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func with(_ authenticationService: AuthenticationService) -> MessagesModuleBuilder {
        self.authenticationService = authenticationService
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

    func with(_ presentationStrings: PresentationStrings) -> MessagesModuleBuilder {
        self.presentationStrings = presentationStrings
        return self
    }

    func build() -> MessagesModuleProviding {
        return PhoneMessagesModuleFactory(sceneFactory: sceneFactory,
                                          authenticationService: authenticationService,
                                          privateMessagesService: privateMessagesService,
                                          dateFormatter: dateFormatter,
                                          presentationStrings: presentationStrings)
    }

}
