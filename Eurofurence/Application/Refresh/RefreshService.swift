//
//  RefreshService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol RefreshService {

    func add(_ observer: RefreshServiceObserver)

    @discardableResult
    func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress

}

protocol RefreshServiceObserver {

    func refreshServiceDidBeginRefreshing()
    func refreshServiceDidFinishRefreshing()

}
