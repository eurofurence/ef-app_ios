//
//  Message.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol Message {

    var authorName: String { get }
    var receivedDateTime: Date { get }
    var contents: String { get }

}
