//
//  EurofurencePrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct EurofurencePrivateMessagesService: PrivateMessagesService {

    static var shared = EurofurencePrivateMessagesService(app: EurofurenceApplication.shared)

    private let app: EurofurenceApplicationProtocol

    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }

    var unreadMessageCount: Int {
        return app.localPrivateMessages.filter(isUnread).count
    }

    var localMessages: [Message] {
        return app.localPrivateMessages
    }

    func refreshMessages(completionHandler: @escaping (PrivateMessagesRefreshResult) -> Void) {
        app.fetchPrivateMessages { (result) in
            switch result {
            case .success(let messages):
                completionHandler(.success(messages))

            default:
                completionHandler(.failure)
            }
        }
    }

    private func isUnread(_ message: Message) -> Bool {
        return !message.isRead
    }

}
