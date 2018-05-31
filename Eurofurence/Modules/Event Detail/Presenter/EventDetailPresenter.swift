//
//  EventDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class EventDetailPresenter: EventDetailSceneDelegate {

    private struct Binder: EventDetailBinder {

        var viewModel: EventDetailViewModel

        func bindComponent<T>(at indexPath: IndexPath, using componentFactory: T) -> T.Component where T: EventDetailComponentFactory {
            let visitor = ViewModelVisitor(componentFactory: componentFactory)
            viewModel.describe(componentAt: indexPath.item, to: visitor)

            guard let component = visitor.boundComponent else {
                fatalError("Did not bind component at index path: \(indexPath)")
            }

            return component
        }

    }

    private class ViewModelVisitor<T>: EventDetailViewModelVisitor where T: EventDetailComponentFactory {

        private let componentFactory: T
        private(set) var boundComponent: T.Component?

        init(componentFactory: T) {
            self.componentFactory = componentFactory
        }

        func visit(_ viewModel: EventSummaryViewModel) {
            boundComponent = componentFactory.makeEventSummaryComponent { (component) in
                component.setEventTitle(viewModel.title)
                component.setEventSubtitle(viewModel.subtitle)
                component.setEventStartEndTime(viewModel.eventStartEndTime)
                component.setEventLocation(viewModel.location)
                component.setTrackName(viewModel.trackName)
                component.setEventHosts(viewModel.eventHosts)
            }
        }

        func visit(_ viewModel: EventDescriptionViewModel) {
            boundComponent = componentFactory.makeEventDescriptionComponent { (component) in
                component.setEventDescription(viewModel.contents)
            }
        }

        func visit(_ graphic: EventGraphicViewModel) {
            boundComponent = componentFactory.makeEventGraphicComponent { (component) in
                component.setPNGGraphicData(graphic.pngGraphicData)
            }
        }

    }

    private let scene: EventDetailScene
    private let interactor: EventDetailInteractor
    private let event: Event2
    private var viewModel: EventDetailViewModel?

    init(scene: EventDetailScene, interactor: EventDetailInteractor, event: Event2) {
        self.scene = scene
        self.interactor = interactor
        self.event = event

        scene.setDelegate(self)
    }

    func eventDetailSceneDidLoad() {
        interactor.makeViewModel(for: event, completionHandler: eventDetailViewModelReady)
    }

    func eventDetailSceneDidTapFavouriteEventButton() {
        viewModel?.favourite()
    }

    private func eventDetailViewModelReady(_ viewModel: EventDetailViewModel) {
        self.viewModel = viewModel
        scene.bind(numberOfComponents: viewModel.numberOfComponents,
                   using: Binder(viewModel: viewModel))
    }

}
