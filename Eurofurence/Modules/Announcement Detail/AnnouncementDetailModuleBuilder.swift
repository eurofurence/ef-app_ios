//
//  AnnouncementDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

class AnnouncementDetailModuleBuilder {

    private var sceneFactory: AnnouncementDetailSceneFactory
    private var announcementDetailInteractorFactory: AnnouncementDetailInteractorFactory

    init() {
        sceneFactory = StoryboardAnnouncementDetailSceneFactory()
        announcementDetailInteractorFactory = DefaultAnnouncementDetailInteractorFactory()
    }

    @discardableResult
    func with(_ sceneFactory: AnnouncementDetailSceneFactory) -> AnnouncementDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ announcementDetailInteractorFactory: AnnouncementDetailInteractorFactory) -> AnnouncementDetailModuleBuilder {
        self.announcementDetailInteractorFactory = announcementDetailInteractorFactory
        return self
    }

    func build() -> AnnouncementDetailModuleProviding {
        return AnnouncementDetailModule(sceneFactory: sceneFactory,
                                        announcementDetailInteractorFactory: announcementDetailInteractorFactory)
    }

}
