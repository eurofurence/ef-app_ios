//
//  NewsModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct NewsModule: NewsModuleProviding {

    var newsSceneFactory: NewsSceneFactory
    var newsInteractor: NewsInteractor

    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        let scene = newsSceneFactory.makeNewsScene()
        _ = NewsPresenter(delegate: delegate,
                          newsScene: scene,
                          newsInteractor: newsInteractor)

        return scene
    }

}
