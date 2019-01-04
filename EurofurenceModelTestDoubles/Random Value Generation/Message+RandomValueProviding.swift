//
//  Message+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import RandomDataGeneration

extension APIMessage: RandomValueProviding {

    public static var random: APIMessage {
        return APIMessage(identifier: .random,
                       authorName: .random,
                       receivedDateTime: .random,
                       subject: .random,
                       contents: .random,
                       isRead: .random)
    }

}
