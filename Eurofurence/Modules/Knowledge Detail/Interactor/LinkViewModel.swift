//
//  LinkViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct LinkViewModel: Equatable {

    var name: String

    static func ==(lhs: LinkViewModel, rhs: LinkViewModel) -> Bool {
        return lhs.name == rhs.name
    }

}
