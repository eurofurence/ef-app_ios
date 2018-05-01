//
//  NewsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class NewsPresenter: NewsSceneDelegate, NewsInteractorDelegate {

    // MARK: Nested Types

    private struct Binder: NewsComponentsBinder {

        var viewModel: NewsViewModel

        func bindTitleForSection(at index: Int, scene: NewsComponentHeaderScene) {
            scene.setComponentTitle(viewModel.titleForComponent(at: index))
        }

        func bindComponent<T>(at indexPath: IndexPath, using componentFactory: T) -> T.Component where T: NewsComponentFactory {
            let visitor = Visitor(componentFactory: componentFactory)
            viewModel.describeComponent(at: indexPath, to: visitor)

            guard let component = visitor.boundComponent else {
                fatalError("Did not bind component at index path: \(indexPath)")
            }

            return component
        }

    }

    private class Visitor<T>: NewsViewModelVisitor where T: NewsComponentFactory {

        private let componentFactory: T
        private(set) var boundComponent: T.Component!

        init(componentFactory: T) {
            self.componentFactory = componentFactory
        }

        func visit(_ countdown: ConventionCountdownComponentViewModel) {
            boundComponent = componentFactory.makeConventionCountdownComponent() { (component) in
                component.setTimeUntilConvention(countdown.timeUntilConvention)
            }
        }

        func visit(_ userWidget: UserWidgetComponentViewModel) {
            boundComponent = componentFactory.makeUserWidgetComponent() { (component) in
                component.setPrompt(userWidget.prompt)
                component.setDetailedPrompt(userWidget.detailedPrompt)

                if userWidget.hasUnreadMessages {
                    component.showHighlightedUserPrompt()
                    component.hideStandardUserPrompt()
                } else {
                    component.showStandardUserPrompt()
                    component.hideHighlightedUserPrompt()
                }
            }
        }

        func visit(_ announcement: AnnouncementComponentViewModel) {
            boundComponent = componentFactory.makeAnnouncementComponent() { (component) in
                component.setAnnouncementTitle(announcement.title)
                component.setAnnouncementDetail(announcement.detail)
            }
        }

        func visit(_ event: EventComponentViewModel) {
            boundComponent = componentFactory.makeEventComponent() { (component) in
                component.setEventStartTime(event.startTime)
                component.setEventEndTime(event.endTime)
                component.setEventName(event.eventName)
                component.setLocation(event.location)
                component.setIcon(event.icon)
            }
        }

    }

    // MARK: Properties

    private let delegate: NewsModuleDelegate
    private let newsScene: NewsScene
    private let newsInteractor: NewsInteractor
    private var viewModel: NewsViewModel?

    // MARK: Initialization

    init(delegate: NewsModuleDelegate,
         newsScene: NewsScene,
         newsInteractor: NewsInteractor) {
        self.delegate = delegate
        self.newsScene = newsScene
        self.newsInteractor = newsInteractor

        newsScene.delegate = self
        newsScene.showNewsTitle(.news)
    }

    // MARK: NewsSceneDelegate

    func newsSceneWillAppear() {
        newsInteractor.subscribeViewModelUpdates(self)
    }

    func newsSceneDidSelectComponent(at indexPath: IndexPath) {
        delegate.newsModuleDidRequestShowingPrivateMessages()

        viewModel?.fetchModelValue(at: indexPath) { (model) in
            switch model {
            case .announcement(let announcement):
                self.delegate.newsModuleDidSelectAnnouncement(announcement)
            }
        }
    }

    // MARK: NewsInteractorDelegate

    func viewModelDidUpdate(_ viewModel: NewsViewModel) {
        self.viewModel = viewModel

        let itemsPerComponent = (0..<viewModel.numberOfComponents).map(viewModel.numberOfItemsInComponent)
        let binder = Binder(viewModel: viewModel)
        newsScene.bind(numberOfItemsPerComponent: itemsPerComponent, using: binder)
    }

}
