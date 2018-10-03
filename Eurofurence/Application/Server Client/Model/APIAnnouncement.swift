//
//  APIAnnouncement.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct APIAnnouncement: Equatable {

    public var identifier: String
    public var title: String
    public var content: String
    public var lastChangedDateTime: Date
    public var imageIdentifier: String?

    public init(identifier: String, title: String, content: String, lastChangedDateTime: Date, imageIdentifier: String?) {
        self.identifier = identifier
        self.title = title
        self.content = content
        self.lastChangedDateTime = lastChangedDateTime
        self.imageIdentifier = imageIdentifier
    }

}
