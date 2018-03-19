//
//  LinkRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol LinkLookupService {

    func resolveAction(for link: Link) -> LinkRouterAction?

}

enum LinkRouterAction {
    case web(URL)
}
