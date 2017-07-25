//
//  APIPrivateMessagesResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol APIPrivateMessagesResponse {

    var messages: [APIPrivateMessage] { get }

}

protocol APIPrivateMessage {

    var id: String { get }
    var subject: String { get }
    var authorName: String { get }
    var message: String { get }
    var recipientUid: String { get }

}
