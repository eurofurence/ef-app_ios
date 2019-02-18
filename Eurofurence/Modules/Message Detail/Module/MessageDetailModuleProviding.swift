//
//  MessageDetailModuleProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit.UIViewController

protocol MessageDetailModuleProviding {

    func makeMessageDetailModule(message: MessageEntity) -> UIViewController

}
