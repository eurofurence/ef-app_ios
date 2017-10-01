//
//  PreloadService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 01/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol PreloadService {

    func beginPreloading(delegate: PreloadServiceDelegate)

}

protocol PreloadServiceDelegate {

    func preloadServiceDidFail()
    func preloadServiceDidFinish()
    func preloadServiceDidProgress(currentUnitCount: Int, totalUnitCount: Int)

}
