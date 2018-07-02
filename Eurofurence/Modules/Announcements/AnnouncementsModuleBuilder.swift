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
    private var announcementsInteractor: AnnouncementsInteractor

    init() {
        struct DummyAnnouncementsInteractor: AnnouncementsInteractor {
            func makeViewModel(completionHandler: @escaping (AnnouncementsListViewModel) -> Void) {

            }
        }

        announcementsSceneFactory = StoryboardAnnouncementsSceneFactory()
        announcementsInteractor = DummyAnnouncementsInteractor()
    }

    func build() -> AnnouncementsModuleProviding {
        return AnnouncementsModule(announcementsSceneFactory: announcementsSceneFactory,
                                   announcementsInteractor: announcementsInteractor)
    }

    @discardableResult
    func with(_ announcementsSceneFactory: AnnouncementsSceneFactory) -> AnnouncementsModuleBuilder {
        self.announcementsSceneFactory = announcementsSceneFactory
        return self
    }

    @discardableResult
    func with(_ announcementsInteractor: AnnouncementsInteractor) -> AnnouncementsModuleBuilder {
        self.announcementsInteractor = announcementsInteractor
        return self
    }

}
