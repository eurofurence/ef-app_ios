//
//  DefaultNewsInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import XCTest

class DefaultNewsInteractorTestBuilder {
    
    struct Context {
        var interactor: DefaultNewsInteractor
        var delegate: CapturingNewsInteractorDelegate
        var authenticationService: FakeAuthenticationService
        var announcementsService: StubAnnouncementsService
        var privateMessagesService: CapturingPrivateMessagesService
        var daysUntilConventionService: StubDaysUntilConventionService
    }
    
    private var announcementsService: StubAnnouncementsService
    private var authenticationService: FakeAuthenticationService
    private var privateMessagesService: CapturingPrivateMessagesService
    private var daysUntilConventionService: StubDaysUntilConventionService
    
    init() {
        announcementsService = StubAnnouncementsService(announcements: [])
        authenticationService = FakeAuthenticationService(authState: .loggedOut)
        privateMessagesService = CapturingPrivateMessagesService()
        daysUntilConventionService = StubDaysUntilConventionService()
    }
    
    @discardableResult
    func with(_ announcementsService: StubAnnouncementsService) -> DefaultNewsInteractorTestBuilder {
        self.announcementsService = announcementsService
        return self
    }
    
    @discardableResult
    func with(_ authService: FakeAuthenticationService) -> DefaultNewsInteractorTestBuilder {
        self.authenticationService = authService
        return self
    }
    
    @discardableResult
    func with(_ privateMessagesService: CapturingPrivateMessagesService) -> DefaultNewsInteractorTestBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }
    
    func build() -> Context {
        let interactor = DefaultNewsInteractor(announcementsService: announcementsService,
                                               authenticationService: authenticationService,
                                               privateMessagesService: privateMessagesService,
                                               daysUntilConventionService: daysUntilConventionService)
        let delegate = CapturingNewsInteractorDelegate()
        
        return Context(interactor: interactor,
                       delegate: delegate,
                       authenticationService: authenticationService,
                       announcementsService: announcementsService,
                       privateMessagesService: privateMessagesService,
                       daysUntilConventionService: daysUntilConventionService)
    }
    
}

// MARK: Convenience Functions

extension DefaultNewsInteractorTestBuilder.Context {
    
    var announcements: [Announcement2] {
        return announcementsService.announcements
    }
    
    func makeExpectedUserWidget() -> AnyHashable {
        switch authenticationService.authState {
        case .loggedIn(let user):
            return UserWidgetComponentViewModel(prompt: String.welcomePrompt(for: user),
                                                detailedPrompt: String.welcomeDescription(messageCount: privateMessagesService.unreadCount),
                                                hasUnreadMessages: false) // TODO: Take unread messages into account
            
        case .loggedOut:
            return UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                detailedPrompt: .anonymousUserLoginDescription,
                                                hasUnreadMessages: false)
        }
    }
    
    func makeDaysUntilConventionWidget() -> AnyHashable {
        return ConventionCountdownComponentViewModel(timeUntilConvention: String.daysUntilConventionMessage(days: daysUntilConventionService.stubbedDays))
    }
    
    func makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements() -> [AnyHashable] {
        return announcements.map(makeExpectedAnnouncementViewModel).map(AnyHashable.init)
    }
    
    func makeExpectedAnnouncementViewModel(from announcement: Announcement2) -> AnnouncementComponentViewModel {
        return AnnouncementComponentViewModel(title: announcement.title, detail: announcement.content)
    }
    
}

// MARK: Assertion Assistance

extension DefaultNewsInteractorTestBuilder {
    
    struct Expectation {
        
        var components: [AnyHashable]
        var titles: [String]
        
        fileprivate func verify(components: [AnyHashable], titles: [String?], file: StaticString, line: UInt) {
            guard self.components.count == components.count else {
                XCTFail("Expected \(self.components.count) components, but got \(components.count)",
                    file: file,
                    line: line)
                return
            }
            
            for (idx, expected) in self.components.enumerated() {
                let actual = components[idx]
                if expected != actual {
                    XCTFail("Components at index \(idx) not equal: Expected \(expected), but got \(actual)", file: file, line: line)
                    return
                }
            }
            
            guard self.titles.count == titles.count else {
                XCTFail("Expected \(self.titles.count) titles, but got \(titles.count)",
                    file: file,
                    line: line)
                return
            }
            
            for (idx, expected) in self.titles.enumerated() {
                let actual = titles[idx]
                if expected != actual {
                    XCTFail("Titles at index \(idx) not equal: Expected \(String(describing: expected)), but got \(String(describing: actual))",
                        file: file,
                        line: line)
                    return
                }
            }
        }
        
    }
    
}

extension DefaultNewsInteractorTestBuilder.Context {
    
    func subscribeViewModelUpdates() {
        interactor.subscribeViewModelUpdates(delegate)
    }
    
    private class Visitor: NewsViewModelVisitor {
        let visitedViewModel: NewsViewModel
        var components = [AnyHashable]()
        var moduleModels = [IndexPath : NewsViewModelValue]()
        
        init(visitedViewModel: NewsViewModel) {
            self.visitedViewModel = visitedViewModel
        }
        
        func visit(_ userWidget: UserWidgetComponentViewModel) {
            components.append(AnyHashable(userWidget))
        }
        
        func visit(_ announcement: AnnouncementComponentViewModel) {
            components.append(AnyHashable(announcement))
        }
        
        func visit(_ event: EventComponentViewModel) {
            components.append(AnyHashable(event))
        }
        
        func visit(_ countdown: ConventionCountdownComponentViewModel) {
            components.append(AnyHashable(countdown))
        }
    }
    
    func verify(_ expectation: DefaultNewsInteractorTestBuilder.Expectation, file: StaticString = #file, line: UInt = #line) {
        if let visitor = traverseViewModel() {
            let viewModel = visitor.visitedViewModel
            let titles = (0..<viewModel.numberOfComponents).map(viewModel.titleForComponent)
            
            expectation.verify(components: visitor.components, titles: titles, file: file, line: line)
        }
    }
    
    func verifyModel(at indexPath: IndexPath, is expected: NewsViewModelValue, file: StaticString = #file, line: UInt = #line) {
        if let visitor = traverseViewModel() {
            guard let actual = visitor.moduleModels[indexPath] else {
                XCTFail("Did not resolve a module model at index path \(indexPath)", file: file, line: line)
                return
            }
            
            XCTAssertEqual(expected, actual, file: file, line: line)
        }
    }
    
    private func traverseViewModel(file: StaticString = #file, line: UInt = #line) -> Visitor? {
        if let viewModel = delegate.viewModel {
            let visitor = Visitor(visitedViewModel: viewModel)
            traverse(through: viewModel, using: visitor)
            return visitor
        }
        else {
            XCTFail("Did not witness a view model", file: file, line: line)
            return nil
        }
    }
    
    private func traverse(through viewModel: NewsViewModel, using visitor: Visitor) {
        var indexPaths = [IndexPath]()
        let numberOfComponents = viewModel.numberOfComponents
        
        for section in (0..<numberOfComponents) {
            for index in (0..<viewModel.numberOfItemsInComponent(at: section)) {
                let indexPath = IndexPath(row: index, section: section)
                indexPaths.append(indexPath)
            }
        }
        
        indexPaths.forEach({ viewModel.describeComponent(at: $0, to: visitor) })
        indexPaths.forEach({ (indexPath) in
            viewModel.fetchModelValue(at: indexPath, completionHandler: { (model) in
                visitor.moduleModels[indexPath] = model
            })
        })
    }
    
}
