//
//  PrivateMessagesController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

class PrivateMessagesController {

    private let privateMessagesAPI: PrivateMessagesAPI
    private var userAuthenticationToken: String?

    private(set) var localPrivateMessages: [Message] = []

    init(eventBus: EventBus, privateMessagesAPI: PrivateMessagesAPI) {
        self.privateMessagesAPI = privateMessagesAPI
        eventBus.subscribe(userLoggedIn)
    }

    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        if let token = userAuthenticationToken {
            privateMessagesAPI.loadPrivateMessages(authorizationToken: token) { (messages) in
                if let messages = messages {
                    let messages = messages.sorted()
                    self.localPrivateMessages = messages
                    completionHandler(.success(messages))
                } else {
                    completionHandler(.failedToLoad)
                }
            }
        } else {
            completionHandler(.userNotAuthenticated)
        }
    }

    func markMessageAsRead(_ message: Message) {
        guard let token = userAuthenticationToken else { return }
        privateMessagesAPI.markMessageWithIdentifierAsRead(message.identifier, authorizationToken: token)
    }

    private func userLoggedIn(_ event: DomainEvent.LoggedIn) {
        userAuthenticationToken = event.authenticationToken
    }

}
