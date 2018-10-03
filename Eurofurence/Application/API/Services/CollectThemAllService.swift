//
//  CollectThemAllService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol CollectThemAllService {

    func subscribe(_ observer: CollectThemAllURLObserver)

}

public protocol CollectThemAllURLObserver {

    func collectThemAllGameRequestDidChange(_ urlRequest: URLRequest)

}
