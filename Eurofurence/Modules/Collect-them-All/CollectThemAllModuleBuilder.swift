//
//  CollectThemAllModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class CollectThemAllModuleBuilder {

    func build() -> CollectThemAllModuleProviding {
        struct DummyCollectThemAllModuleProviding: CollectThemAllModuleProviding {
            func makeCollectThemAllModule() -> UIViewController {
                return UIViewController()
            }
        }

        return DummyCollectThemAllModuleProviding()
    }

}
