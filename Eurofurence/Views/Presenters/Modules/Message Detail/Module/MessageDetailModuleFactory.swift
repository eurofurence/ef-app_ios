//
//  MessageDetailModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct MessageDetailModuleFactory: MessageDetailModuleProviding {

    var messageDetailSceneFactory: MessageDetailSceneFactory

    func makeMessageDetailModule(message: Message) -> UIViewController {
        _ = MessageDetailPresenter(message: message, scene: messageDetailSceneFactory.makeMessageDetailScene())
        return UIViewController()
    }

}
