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

    private var announcementsSceneFactory: AnnouncementsSceneFactory

    init() {
        announcementsSceneFactory = StoryboardAnnouncementsSceneFactory()
    }

    func build() -> AnnouncementsModuleProviding {
        return AnnouncementsModule(announcementsSceneFactory: announcementsSceneFactory)
    }

    @discardableResult
    func with(_ announcementsSceneFactory: AnnouncementsSceneFactory) -> AnnouncementsModuleBuilder {
        self.announcementsSceneFactory = announcementsSceneFactory
        return self
    }

}
