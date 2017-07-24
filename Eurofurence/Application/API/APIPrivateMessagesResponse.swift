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

    var authorName: String { get }

}
