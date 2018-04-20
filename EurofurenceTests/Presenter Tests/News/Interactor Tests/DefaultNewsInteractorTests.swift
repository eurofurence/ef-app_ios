//
//  DefaultNewsInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

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

class CapturingNewsInteractorDelegate: NewsInteractorDelegate {
    
    private var viewModel: NewsViewModel?
    func viewModelDidUpdate(_ viewModel: NewsViewModel) {
        self.viewModel = viewModel
    }
    
    func didWitnessViewModelWithComponents(_ components: [AnyHashable]) -> Bool {
        class Visitor: NewsViewModelVisitor {
            var components = [AnyHashable]()
            
            func visit(_ userWidget: UserWidgetComponentViewModel) {
                components.append(AnyHashable(userWidget))
            }
            
            func visit(_ announcement: AnnouncementComponentViewModel) {
                components.append(AnyHashable(announcement))
            }
            
            func visit(_ event: EventComponentViewModel) {
                components.append(AnyHashable(event))
            }
        }
        
        let visitor = Visitor()
        if let viewModel = viewModel {
            var indexPaths = [IndexPath]()
            for section in (0..<viewModel.numberOfComponents) {
                for index in (0..<viewModel.numberOfItemsInComponent(at: section)) {
                    let indexPath = IndexPath(row: index, section: section)
                    indexPaths.append(indexPath)
                }
            }
            
            indexPaths.forEach({ viewModel.describeComponent(at: $0, to: visitor) })
        }
        
        return visitor.components == components
    }
    
}

class DefaultNewsInteractorTests: XCTestCase {
    
    func testNotBeingLoggedInEmitsViewModelWithLoginPromptUserWidgetViewModel() {
        let loggedOutAuthService = FakeAuthenticationService(authState: .loggedOut)
        let delegate = CapturingNewsInteractorDelegate()
        let interactor = DefaultNewsInteractor(authenticationService: loggedOutAuthService)
        interactor.subscribeViewModelUpdates(delegate)
        let expectedViewModel = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                             detailedPrompt: .anonymousUserLoginDescription,
                                                             hasUnreadMessages: false)
        let expected = [AnyHashable(expectedViewModel)]
        
        XCTAssertTrue(delegate.didWitnessViewModelWithComponents(expected))
    }
    
}
