//
//  AppDataBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct AppDataBuilder {
    
    static func makeMessage(identifier: String = "Identifier",
                            authorName: String = "Author",
                            receivedDateTime: Date = Date(),
                            subject: String = "Subject",
                            contents: String = "Contents",
                            read: Bool = false) -> Message {
        return Message(identifier: identifier,
                       authorName: authorName,
                       receivedDateTime: receivedDateTime,
                       subject: subject,
                       contents: contents,
                       isRead: read)
    }
    
}
