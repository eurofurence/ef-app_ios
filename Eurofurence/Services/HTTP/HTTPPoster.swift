//
//  HTTPPoster.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol HTTPPoster {

    func post(_ url: String, body: Data)

}
