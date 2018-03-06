//
//  ApplicationPreloadingService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct ApplicationPreloadingService: PreloadService {

    var app: EurofurenceApplicationProtocol

    func beginPreloading(delegate: PreloadServiceDelegate) {
        app.refreshLocalStore()
    }

}
