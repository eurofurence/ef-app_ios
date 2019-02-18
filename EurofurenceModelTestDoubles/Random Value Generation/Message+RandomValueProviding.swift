//
//  MessageCharacteristics+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import RandomDataGeneration

extension MessageCharacteristics: RandomValueProviding {

    public static var random: MessageCharacteristics {
        return MessageCharacteristics(identifier: .random,
                                      authorName: .random,
                                      receivedDateTime: .random,
                                      subject: .random,
                                      contents: .random,
                                      isRead: .random)
    }

}
