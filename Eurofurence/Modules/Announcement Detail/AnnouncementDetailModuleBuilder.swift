//
//  AnnouncementDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

class AnnouncementDetailModuleBuilder {

    private var sceneFactory: AnnouncementDetailSceneFactory
    private var announcementDetailInteractor: AnnouncementDetailInteractor

    init() {
        struct DummyAnnouncementDetailInteractor: AnnouncementDetailInteractor {
            func makeViewModel(completionHandler: @escaping (AnnouncementViewModel) -> Void) {

            }
        }

        sceneFactory = StoryboardAnnouncementDetailSceneFactory()
        announcementDetailInteractor = DummyAnnouncementDetailInteractor()
    }

    @discardableResult
    func with(_ sceneFactory: AnnouncementDetailSceneFactory) -> AnnouncementDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ announcementDetailInteractor: AnnouncementDetailInteractor) -> AnnouncementDetailModuleBuilder {
        self.announcementDetailInteractor = announcementDetailInteractor
        return self
    }

    func build() -> AnnouncementDetailModuleProviding {
        return AnnouncementDetailModule(sceneFactory: sceneFactory,
                                        announcementDetailInteractor: announcementDetailInteractor)
    }

}
