//
//  WebModuleProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIViewController

protocol WebModuleProviding {

    func makeWebModule(for url: URL) -> UIViewController

}
