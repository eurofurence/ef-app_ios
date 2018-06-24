//
//  CollectThemAllPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct CollectThemAllPresenter: CollectThemAllURLObserver {

    private let scene: CollectThemAllScene

    init(scene: CollectThemAllScene, service: CollectThemAllService) {
        self.scene = scene
        service.subscribe(self)
    }

    func collectThemAllGameRequestDidChange(_ urlRequest: URLRequest) {
        scene.loadGame(at: urlRequest)
    }

}
