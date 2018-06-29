//
//  PreloadInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 01/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol PreloadInteractor {

    func beginPreloading(delegate: PreloadInteractorDelegate)

}

protocol PreloadInteractorDelegate {

    func preloadInteractorDidFailToPreload()
    func preloadInteractorDidFinishPreloading()
    func preloadInteractorDidProgress(currentUnitCount: Int, totalUnitCount: Int, localizedDescription: String)

}
