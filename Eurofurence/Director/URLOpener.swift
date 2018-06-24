//
//  URLOpener.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol URLOpener {

    func canOpen(_ url: URL) -> Bool
    func open(_ url: URL)

}
