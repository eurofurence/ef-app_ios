//
//  PhoneMessagesSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct PhoneMessagesSceneFactory: MessagesSceneFactory {

    func makeMessagesScene() -> UIViewController & MessagesScene {
        return MessagesViewControllerV2()
    }

}
