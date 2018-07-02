//
//  AnnouncementsModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

class AnnouncementsModuleBuilder {

    func build() -> AnnouncementsModuleProviding {
        struct DummyAnnouncementsModuleProviding: AnnouncementsModuleProviding {
            func makeAnnouncementsModule() -> UIViewController {
                return UIViewController()
            }
        }

        return DummyAnnouncementsModuleProviding()
    }

}
