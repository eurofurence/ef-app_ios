//
//  DefaultNewsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DefaultNewsInteractor: NewsInteractor {

    private let authenticationService: AuthenticationService

    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }

    func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate) {
        let userWidget = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                      detailedPrompt: .anonymousUserLoginDescription,
                                                      hasUnreadMessages: false)
        let viewModel = ViewModel(components: [.userWidget(userWidget)])
        delegate.viewModelDidUpdate(viewModel)
    }

    private enum Component {
        case userWidget(UserWidgetComponentViewModel)
    }

    private struct ViewModel: NewsViewModel {

        private let components: [Component]

        init(components: [Component]) {
            self.components = components
        }

        var numberOfComponents: Int = 1

        func numberOfItemsInComponent(at index: Int) -> Int {
            return 1
        }

        func titleForComponent(at index: Int) -> String {
            return ""
        }

        func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
            if let component = components.first, case .userWidget(let vm) = component {
                visitor.visit(vm)
            }
        }

    }

}
