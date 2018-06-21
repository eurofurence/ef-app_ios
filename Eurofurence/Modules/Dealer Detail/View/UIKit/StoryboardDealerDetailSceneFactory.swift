//
//  StoryboardDealerDetailSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardDealerDetailSceneFactory: DealerDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "DealerDetail", bundle: .main)

    func makeDealerDetailScene() -> UIViewController & DealerDetailScene {
        return storyboard.instantiate(DealerDetailViewController.self)
    }

}
