//
//  RestorationIdentifierOrderingPolicy.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class RestorationIdentifierOrderingPolicy: ModuleOrderingPolicy {

    private let userDefaults = UserDefaults.standard
    private struct Keys {
        static let tabOrderKey = "EFModuleRestorationIdentifiers"
    }

    func order(modules: [UIViewController]) -> [UIViewController] {
        guard let order = userDefaults.stringArray(forKey: Keys.tabOrderKey) else { return modules }

        return modules.sorted(by: { (first, second) -> Bool in
            guard let firstIdentifier = first.restorationIdentifier,
                  let secondIdentifier = second.restorationIdentifier,
                  let firstIndex = order.firstIndex(of: firstIdentifier),
                  let secondIndex = order.firstIndex(of: secondIdentifier) else { return false }

            return firstIndex < secondIndex
        })
    }

    func saveOrder(_ modules: [UIViewController]) {
        let restorationIdentifiers = modules.compactMap({ $0.restorationIdentifier })
        userDefaults.setValue(restorationIdentifiers, forKey: Keys.tabOrderKey)
    }

}
