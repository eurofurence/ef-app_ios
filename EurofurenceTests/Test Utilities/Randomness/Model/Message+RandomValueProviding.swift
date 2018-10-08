//
//  Message+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import RandomDataGeneration

extension Message: RandomValueProviding {
    
    public static var random: Message {
        return Message(identifier: .random,
                       authorName: .random,
                       receivedDateTime: .random,
                       subject: .random,
                       contents: .random,
                       isRead: .random)
    }
    
}
