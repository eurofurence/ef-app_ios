import Foundation

class NewsPresenter: NewsSceneDelegate, NewsViewModelRecipient {

    // MARK: Nested Types

    private struct Binder: NewsComponentsBinder {

        var viewModel: NewsViewModel

        func bindTitleForSection(at index: Int, scene: NewsComponentHeaderScene) {
            scene.setComponentTitle(viewModel.titleForComponent(at: index))
        }

        func bindComponent<T>(
            at indexPath: IndexPath,
            using componentFactory: T
        ) -> T.Component where T: NewsItemComponentFactory {
            let visitor = Visitor(componentFactory: componentFactory)
            viewModel.describeComponent(at: indexPath, to: visitor)

            guard let component = visitor.boundComponent else {
                fatalError("Did not bind component at index path: \(indexPath)")
            }

            return component
        }

    }

    private class Visitor<T>: NewsViewModelVisitor where T: NewsItemComponentFactory {

        private let componentFactory: T
        private(set) var boundComponent: T.Component!

        init(componentFactory: T) {
            self.componentFactory = componentFactory
        }

        func visit(_ countdown: ConventionCountdownComponentViewModel) {
            boundComponent = componentFactory.makeConventionCountdownComponent { (component) in
                component.setTimeUntilConvention(countdown.timeUntilConvention)
            }
        }

        func visit(_ userWidget: UserWidgetComponentViewModel) {
            boundComponent = componentFactory.makeUserWidgetComponent { (component) in
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

        func visit(_ announcement: AnnouncementItemViewModel) {
            boundComponent = componentFactory.makeAnnouncementComponent { (component) in
                component.setAnnouncementTitle(announcement.title)
                component.setAnnouncementDetail(announcement.detail)
                component.setAnnouncementReceivedDateTime(announcement.receivedDateTime)

                if announcement.isRead {
                    component.hideUnreadIndicator()
                } else {
                    component.showUnreadIndicator()
                }
            }
        }

        func visit(_ viewAllAnnouncements: ViewAllAnnouncementsComponentViewModel) {
            boundComponent = componentFactory.makeAllAnnouncementsComponent { (component) in
                component.showCaption(viewAllAnnouncements.caption)
            }
        }

        func visit(_ event: EventComponentViewModel) {
            boundComponent = componentFactory.makeEventComponent { (component) in
                component.setEventStartTime(event.startTime)
                component.setEventEndTime(event.endTime)
                component.setEventName(event.eventName)
                component.setLocation(event.location)

                if event.isSponsorEvent {
                    component.showSponsorEventIndicator()
                } else {
                    component.hideSponsorEventIndicator()
                }

                if event.isSuperSponsorEvent {
                    component.showSuperSponsorOnlyEventIndicator()
                } else {
                    component.hideSuperSponsorOnlyEventIndicator()
                }

                if event.isFavourite {
                    component.showFavouriteEventIndicator()
                } else {
                    component.hideFavouriteEventIndicator()
                }

                if event.isArtShowEvent {
                    component.showArtShowEventIndicator()
                } else {
                    component.hideArtShowEventIndicator()
                }

                if event.isKageEvent {
                    component.showKageEventIndicator()
                } else {
                    component.hideKageEventIndicator()
                }

                if event.isDealersDenEvent {
                    component.showDealersDenEventIndicator()
                } else {
                    component.hideDealersDenEventIndicator()
                }

                if event.isMainStageEvent {
                    component.showMainStageEventIndicator()
                } else {
                    component.hideMainStageEventIndicator()
                }

                if event.isPhotoshootEvent {
                    component.showPhotoshootStageEventIndicator()
                } else {
                    component.hidePhotoshootStageEventIndicator()
                }
            }
        }

    }

    // MARK: Properties

    private let delegate: NewsComponentDelegate
    private let newsScene: NewsScene
    private let newsInteractor: NewsViewModelProducer
    private var viewModel: NewsViewModel?

    // MARK: Initialization

    init(delegate: NewsComponentDelegate,
         newsScene: NewsScene,
         newsInteractor: NewsViewModelProducer) {
        self.delegate = delegate
        self.newsScene = newsScene
        self.newsInteractor = newsInteractor

        newsScene.delegate = self
        newsScene.showNewsTitle(.news)
    }

    // MARK: NewsSceneDelegate

    func newsSceneDidLoad() {
        newsInteractor.subscribeViewModelUpdates(self)
    }

    func newsSceneDidSelectComponent(at indexPath: IndexPath) {
        viewModel?.fetchModelValue(at: indexPath) { (model) in
            switch model {
            case .announcement(let announcement):
                self.delegate.newsModuleDidSelectAnnouncement(announcement)

            case .messages:
                self.delegate.newsModuleDidRequestShowingPrivateMessages()

            case .event(let event):
                self.delegate.newsModuleDidSelectEvent(event)

            case .allAnnouncements:
                self.delegate.newsModuleDidRequestShowingAllAnnouncements()
            }
        }
    }

    func newsSceneDidPerformRefreshAction() {
        newsInteractor.refresh()
    }

    // MARK: NewsViewModelRecipient

    func viewModelDidUpdate(_ viewModel: NewsViewModel) {
        self.viewModel = viewModel

        let itemsPerComponent = (0..<viewModel.numberOfComponents).map(viewModel.numberOfItemsInComponent)
        let binder = Binder(viewModel: viewModel)
        newsScene.bind(numberOfItemsPerComponent: itemsPerComponent, using: binder)
    }

    func refreshDidBegin() {
        newsScene.showRefreshIndicator()
    }

    func refreshDidFinish() {
        newsScene.hideRefreshIndicator()
    }

}
