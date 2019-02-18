//
//  Message.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public protocol Message {

    var identifier: String { get }
    var authorName: String { get }
    var receivedDateTime: Date { get }
    var subject: String { get }
    var contents: String { get }
    var isRead: Bool { get }

}
