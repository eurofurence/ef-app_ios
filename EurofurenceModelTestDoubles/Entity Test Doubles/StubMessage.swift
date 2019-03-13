//
//  StubMessage.swift
//  EurofurenceModelTestDoubles
//
//  Created by Thomas Sherwood on 18/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import TestUtilities

public struct StubMessage: Message {

    public var identifier: String
    public var authorName: String
    public var receivedDateTime: Date
    public var subject: String
    public var contents: String
    public var isRead: Bool
    
    public func markAsRead() {
        
    }

}

extension StubMessage: RandomValueProviding {

    public static var random: StubMessage {
        return StubMessage(identifier: .random,
                           authorName: .random,
                           receivedDateTime: .random,
                           subject: .random,
                           contents: .random,
                           isRead: .random)
    }

}
