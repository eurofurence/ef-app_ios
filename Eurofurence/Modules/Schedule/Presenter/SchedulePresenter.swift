//
//  SchedulePresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct SchedulePresenter: ScheduleInteractorDelegate {

    private let scene: ScheduleScene

    init(scene: ScheduleScene, interactor: ScheduleInteractor) {
        self.scene = scene
        interactor.setDelegate(self)
    }

    func scheduleInteractorDidPrepareViewModel(_ viewModel: ScheduleViewModel) {
        scene.bind(numberOfItemsPerSection: viewModel.eventsPerGroup)
    }

}
