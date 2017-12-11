//
//  MessageDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class MessageDetailModuleBuilder {

    private struct DummyMessageDetailModuleProviding: MessageDetailModuleProviding {
        func makeMessageDetailModule(message: Message) -> UIViewController {
            return UIViewController()
        }
    }

    func build() -> MessageDetailModuleProviding {
        return DummyMessageDetailModuleProviding()
    }

}
