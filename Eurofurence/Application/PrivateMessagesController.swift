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
        eventBus.subscribe(consumer: BlockEventConsumer(block: userLoggedIn))
    }

    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        if let token = userAuthenticationToken {
            privateMessagesAPI.loadPrivateMessages(authorizationToken: token) { response in
                switch response {
                case .success(let response):
                    let messages = response.messages.map(self.makeMessage).sorted(by: { (first, second) -> Bool in
                        return first.receivedDateTime.compare(second.receivedDateTime) == .orderedDescending
                    })

                    self.localPrivateMessages = messages
                    completionHandler(.success(messages))

                case .failure:
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

    private func makeMessage(from apiMessage: APIPrivateMessage) -> Message {
        return Message(identifier: apiMessage.id,
                       authorName: apiMessage.authorName,
                       receivedDateTime: apiMessage.receivedDateTime,
                       subject: apiMessage.subject,
                       contents: apiMessage.message,
                       isRead: apiMessage.readDateTime != nil)
    }

}
