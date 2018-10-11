//
//  FakeCollectThemAllService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class FakeCollectThemAllService: CollectThemAllService {

    let urlRequest = URLRequest(url: .random)
    func subscribe(_ observer: CollectThemAllURLObserver) {
        observer.collectThemAllGameRequestDidChange(urlRequest)
    }

}
