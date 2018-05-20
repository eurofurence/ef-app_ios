//
//  EventDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct EventDetailPresenter: EventDetailSceneDelegate {

    private struct Binder: EventDetailBinder {

        var viewModel: EventDetailViewModel

        func bindComponent(at indexPath: IndexPath, using componentFactory: EventDetailComponentFactory) {
            componentFactory.makeEventSummaryComponent { (component) in
                component.setEventTitle(viewModel.title)
                component.setEventStartTime(viewModel.eventStartTime)
                component.setEventLocation(viewModel.location)
            }
        }

    }

    private let scene: EventDetailScene
    private let interactor: EventDetailInteractor
    private let event: Event2

    init(scene: EventDetailScene, interactor: EventDetailInteractor, event: Event2) {
        self.scene = scene
        self.interactor = interactor
        self.event = event

        scene.setDelegate(self)
    }

    func eventDetailSceneDidLoad() {
        interactor.makeViewModel(for: event, completionHandler: eventDetailViewModelReady)
    }

    private func eventDetailViewModelReady(_ viewModel: EventDetailViewModel) {
        scene.bind(using: Binder(viewModel: viewModel))
    }

}
