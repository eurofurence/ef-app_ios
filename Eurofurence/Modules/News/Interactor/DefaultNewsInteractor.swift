//
//  DefaultNewsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

private protocol NewsViewModelComponent {

    var childCount: Int { get }
    var title: String { get }

    func announceContent(at index: Int, to visitor: NewsViewModelVisitor)
    func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void)

}

class DefaultNewsInteractor: NewsInteractor, AuthenticationStateObserver, PrivateMessagesServiceObserver, DaysUntilConventionServiceObserver {

    // MARK: Properties

    private let announcementsService: AnnouncementsService
    private let authenticationService: AuthenticationService
    private var delegate: NewsInteractorDelegate?
    private var unreadMessagesCount = 0
    private var daysUntilConvention = 0

    // MARK: Initialization

    convenience init() {
        struct DummyDaysUntilConventionService: DaysUntilConventionService {
            func observeDaysUntilConvention(using observer: DaysUntilConventionServiceObserver) {
                observer.daysUntilConventionDidChange(to: 42)
            }
        }

        self.init(announcementsService: EurofurenceApplication.shared,
                  authenticationService: ApplicationAuthenticationService.shared,
                  privateMessagesService: EurofurencePrivateMessagesService.shared,
                  daysUntilConventionService: DummyDaysUntilConventionService())
    }

    init(announcementsService: AnnouncementsService,
         authenticationService: AuthenticationService,
         privateMessagesService: PrivateMessagesService,
         daysUntilConventionService: DaysUntilConventionService) {
        self.announcementsService = announcementsService
        self.authenticationService = authenticationService

        authenticationService.add(observer: self)
        privateMessagesService.add(self)
        daysUntilConventionService.observeDaysUntilConvention(using: self)
    }

    // MARK: NewsInteractor

    func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate) {
        self.delegate = delegate
        regenerateViewModel()
    }

    // MARK: AuthenticationStateObserver

    func userDidLogin(_ user: User) {
        regenerateViewModel()
    }

    func userDidLogout() {
        regenerateViewModel()
    }

    // MARK: PrivateMessagesServiceObserver

    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        unreadMessagesCount = unreadCount
        regenerateViewModel()
    }

    func privateMessagesServiceDidFinishRefreshingMessages(_ messages: [Message]) {

    }

    func privateMessagesServiceDidFailToLoadMessages() {

    }

    // MARK: DaysUntilConventionServiceObserver

    func daysUntilConventionDidChange(to daysRemaining: Int) {
        daysUntilConvention = daysRemaining
        regenerateViewModel()
    }

    // MARK: Private

    private func regenerateViewModel() {
        makeUserWidgetViewModel { (userWidget) in
            self.announcementsService.fetchAnnouncements { (announcements) in
                let userWidget = UserComponent(viewModel: userWidget)
                let daysUntilConventionWidget = CountdownComponent(daysUntilConvention: self.daysUntilConvention)
                let announcementsComponents = AnnouncementsComponent(announcements: announcements)
                let viewModel = ViewModel(components: [userWidget, daysUntilConventionWidget, announcementsComponents])
                self.delegate?.viewModelDidUpdate(viewModel)
            }
        }
    }

    private func makeUserWidgetViewModel(_ completionHandler: @escaping (UserWidgetComponentViewModel) -> Void) {
        authenticationService.determineAuthState { (state) in
            let userWidget: UserWidgetComponentViewModel
            switch state {
            case .loggedIn(let user):
                userWidget = UserWidgetComponentViewModel(prompt: .welcomePrompt(for: user),
                                                          detailedPrompt: .welcomeDescription(messageCount: self.unreadMessagesCount),
                                                          hasUnreadMessages: self.unreadMessagesCount > 0)

            case .loggedOut:
                userWidget = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                          detailedPrompt: .anonymousUserLoginDescription,
                                                          hasUnreadMessages: false)
            }

            completionHandler(userWidget)
        }
    }

    private struct UserComponent: NewsViewModelComponent {

        private let viewModel: UserWidgetComponentViewModel

        init(viewModel: UserWidgetComponentViewModel) {
            self.viewModel = viewModel
        }

        var childCount: Int { return 1 }
        var title: String { return .yourEurofurence }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            visitor.visit(viewModel)
        }

        func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
            completionHandler(.messages)
        }

    }

    private struct CountdownComponent: NewsViewModelComponent {

        private let viewModel: ConventionCountdownComponentViewModel

        init(daysUntilConvention: Int) {
            let message = String.daysUntilConventionMessage(days: daysUntilConvention)
            viewModel = ConventionCountdownComponentViewModel(timeUntilConvention: message)
        }

        var childCount: Int {
            return 1
        }

        var title: String {
            return .daysUntilConvention
        }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            visitor.visit(viewModel)
        }

        func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {

        }

    }

    private struct AnnouncementsComponent: NewsViewModelComponent {

        private let announcements: [Announcement2]
        private let viewModels: [AnnouncementComponentViewModel]

        init(announcements: [Announcement2]) {
            self.announcements = announcements
            viewModels = announcements.map({ (announcement) -> AnnouncementComponentViewModel in
                return AnnouncementComponentViewModel(title: announcement.title, detail: announcement.content)
            })
        }

        var childCount: Int { return viewModels.count }
        var title: String { return .announcements }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            let viewModel = viewModels[index]
            visitor.visit(viewModel)
        }

        func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
            let announcement = announcements[index]
            completionHandler(.announcement(announcement))
        }

    }

    private struct ViewModel: NewsViewModel {

        private let components: [NewsViewModelComponent]

        init(components: [NewsViewModelComponent]) {
            self.components = components
        }

        var numberOfComponents: Int {
            return components.count
        }

        func numberOfItemsInComponent(at index: Int) -> Int {
            return components[index].childCount
        }

        func titleForComponent(at index: Int) -> String {
            return components[index].title
        }

        func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
            let component = components[indexPath.section]
            component.announceContent(at: indexPath.item, to: visitor)
        }

        func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {
            components[indexPath.section].announceValue(at: indexPath.item, to: completionHandler)
        }

    }

}
