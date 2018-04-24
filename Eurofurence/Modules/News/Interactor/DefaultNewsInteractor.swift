//
//  DefaultNewsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DefaultNewsInteractor: NewsInteractor {

    private let announcementsService: AnnouncementsService
    private let authenticationService: AuthenticationService

    init(announcementsService: AnnouncementsService, authenticationService: AuthenticationService) {
        self.announcementsService = announcementsService
        self.authenticationService = authenticationService
    }

    func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate) {
        let userWidget = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                      detailedPrompt: .anonymousUserLoginDescription,
                                                      hasUnreadMessages: false)

        announcementsService.fetchAnnouncements { (announcements) in
            let announcementViewModels = announcements.map({ (announcement) -> AnnouncementComponentViewModel in
                return AnnouncementComponentViewModel(title: announcement.title, detail: announcement.content)
            })

            let viewModel = ViewModel(components: [.userWidget(userWidget), .announcements(announcementViewModels)])
            delegate.viewModelDidUpdate(viewModel)
        }
    }

    private enum Component {
        case userWidget(UserWidgetComponentViewModel)
        case announcements([AnnouncementComponentViewModel])

        var childCount: Int {
            switch self {
            case .userWidget(_):
                return 1

            case .announcements(let announcements):
                return announcements.count
            }
        }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            switch self {
            case .userWidget(let widget):
                visitor.visit(widget)

            case .announcements(let announcements):
                let announcement = announcements[index]
                visitor.visit(announcement)
            }
        }
    }

    private struct ViewModel: NewsViewModel {

        private let components: [Component]

        init(components: [Component]) {
            self.components = components
        }

        var numberOfComponents: Int {
            return components.count
        }

        func numberOfItemsInComponent(at index: Int) -> Int {
            return components[index].childCount
        }

        func titleForComponent(at index: Int) -> String {
            return ""
        }

        func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
            let component = components[indexPath.section]
            component.announceContent(at: indexPath.item, to: visitor)
        }

    }

}
