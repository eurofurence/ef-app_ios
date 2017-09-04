//
//  EurofurencePrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct EurofurencePrivateMessagesService: PrivateMessagesService {

    private let app: EurofurenceApplicationProtocol

    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }

    var unreadMessageCount: Int {
        return app.localPrivateMessages.filter(isUnread).count
    }

    func refreshMessages() {

    }

    private func isUnread(_ message: Message) -> Bool {
        return !message.isRead
    }

}
