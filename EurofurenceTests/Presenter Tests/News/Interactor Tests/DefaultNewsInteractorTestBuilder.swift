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
        var relativeTimeFormatter: FakeRelativeTimeIntervalCountdownFormatter
        var authenticationService: FakeAuthenticationService
        var announcementsService: StubAnnouncementsService
        var privateMessagesService: CapturingPrivateMessagesService
        var daysUntilConventionService: StubConventionCountdownService
        var eventsService: StubEventsService
    }
    
    private var announcementsService: StubAnnouncementsService
    private var authenticationService: FakeAuthenticationService
    private var privateMessagesService: CapturingPrivateMessagesService
    private var daysUntilConventionService: StubConventionCountdownService
    private var eventsService: StubEventsService
    
    init() {
        announcementsService = StubAnnouncementsService(announcements: [])
        authenticationService = FakeAuthenticationService(authState: .loggedOut)
        privateMessagesService = CapturingPrivateMessagesService()
        daysUntilConventionService = StubConventionCountdownService()
        eventsService = StubEventsService()
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
    
    @discardableResult
    func with(_ daysUntilConventionService: StubConventionCountdownService) -> DefaultNewsInteractorTestBuilder {
        self.daysUntilConventionService = daysUntilConventionService
        return self
    }
    
    @discardableResult
    func with(_ eventsService: StubEventsService) -> DefaultNewsInteractorTestBuilder {
        self.eventsService = eventsService
        return self
    }
    
    func build() -> Context {
        let relativeTimeFormatter = FakeRelativeTimeIntervalCountdownFormatter()
        let interactor = DefaultNewsInteractor(announcementsService: announcementsService,
                                               authenticationService: authenticationService,
                                               privateMessagesService: privateMessagesService,
                                               daysUntilConventionService: daysUntilConventionService,
                                               eventsService: eventsService,
                                               relativeTimeIntervalCountdownFormatter: relativeTimeFormatter)
        let delegate = CapturingNewsInteractorDelegate()
        
        return Context(interactor: interactor,
                       delegate: delegate,
                       relativeTimeFormatter: relativeTimeFormatter,
                       authenticationService: authenticationService,
                       announcementsService: announcementsService,
                       privateMessagesService: privateMessagesService,
                       daysUntilConventionService: daysUntilConventionService,
                       eventsService: eventsService)
    }
    
}

// MARK: Convenience Functions

extension DefaultNewsInteractorTestBuilder.Context {
    
    var announcements: [Announcement2] {
        return announcementsService.announcements
    }
    
    var runningEvents: [Event2] {
        return eventsService.runningEvents
    }
    
    func makeAssertion() -> AssertionBuilder {
        return AssertionBuilder(context: self)
    }

    class AssertionBuilder {
        
        fileprivate struct Component {
            var title: String
            var components: [AnyHashable]
        }
        
        private let context: DefaultNewsInteractorTestBuilder.Context
        private var components = [Component]()
        
        fileprivate init(context: DefaultNewsInteractorTestBuilder.Context) {
            self.context = context
        }
        
        func verify(file: StaticString = #file, line: UInt = #line) {
            Assertion(file: file, line: line, components: components, viewModel: context.delegate.viewModel).verify()
        }
        
        private var shouldSimulateUserHasUnreadMessages: Bool {
            return context.privateMessagesService.unreadCount > 0
        }
        
        func appendYourEurofurence() -> AssertionBuilder {
            var component: AnyHashable
            switch context.authenticationService.authState {
            case .loggedIn(let user):
                component = UserWidgetComponentViewModel(prompt: String.welcomePrompt(for: user),
                                                         detailedPrompt: String.welcomeDescription(messageCount: context.privateMessagesService.unreadCount),
                                                         hasUnreadMessages: shouldSimulateUserHasUnreadMessages)
                
            case .loggedOut:
                component = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                         detailedPrompt: .anonymousUserLoginDescription,
                                                         hasUnreadMessages: shouldSimulateUserHasUnreadMessages)
            }
            
            components.append(Component(title: .yourEurofurence, components: [component]))
            
            return self
        }
        
        func appendAnnouncements() -> AssertionBuilder {
            let announcementsComponents = context.announcements.map(makeExpectedAnnouncementViewModel)
            components.append(Component(title: .announcements, components: announcementsComponents))
            
            return self
        }
        
        func appendConventionCountdown() -> AssertionBuilder {
            let daysUntilConvention = resolveStubbedDaysUntilConvention()
            let component = ConventionCountdownComponentViewModel(timeUntilConvention: .daysUntilConventionMessage(days: daysUntilConvention))
            components.append(Component(title: .daysUntilConvention, components: [component]))
            
            return self
        }
        
        func appendRunningEvents() -> AssertionBuilder {
            let eventsComponents = context.eventsService.runningEvents.map(makeExpectedEventViewModel)
            components.append(Component(title: .runningEvents, components: eventsComponents))
            
            return self
        }
        
        func appendUpcomingEvents() -> AssertionBuilder {
            components.append(Component(title: .upcomingEvents, components: []))
            return self
        }
        
        private func makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements() -> [AnyHashable] {
            return context.announcements.map(makeExpectedAnnouncementViewModel)
        }
        
        private func makeExpectedAnnouncementViewModel(from announcement: Announcement2) -> AnyHashable {
            return AnnouncementComponentViewModel(title: announcement.title, detail: announcement.content)
        }
        
        private func resolveStubbedDaysUntilConvention() -> Int {
            guard case .countingDown(let days) = context.daysUntilConventionService.countdownState else { return -1 }
            return days
        }
        
        private func makeExpectedEventViewModel(from event: Event2) -> AnyHashable {
            return EventComponentViewModel(startTime: context.relativeTimeFormatter.relativeString(from: event.secondsUntilEventBegins),
                                           endTime: "",
                                           eventName: event.title,
                                           location: event.room.name,
                                           icon: nil)
        }
        
    }

}

fileprivate extension DefaultNewsInteractorTestBuilder.Context {
    
    fileprivate struct Assertion {
        
        var file: StaticString
        var line: UInt
        var components: [AssertionBuilder.Component]
        var viewModel: NewsViewModel?
        
        private class Visitor: NewsViewModelVisitor {
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
            
            func visit(_ countdown: ConventionCountdownComponentViewModel) {
                components.append(AnyHashable(countdown))
            }
        }
        
        func verify() {
            guard let viewModel = viewModel else {
                XCTFail("Delegate did not witness a view model",
                        file: file,
                        line: line)
                return
            }
            
            let actual = traverse(through: viewModel)
            
            guard actual.count == components.count else {
                XCTFail("Expected \(actual.count) components; got \(components.count)",
                    file: file,
                    line: line)
                return
            }
            
            for (idx, component) in components.enumerated() {
                let actualComponent = actual[idx]
                verify(expected: component, actual: actualComponent, index: idx)
            }
        }
        
        private func traverse(through viewModel: NewsViewModel) -> [AssertionBuilder.Component] {
            var actual = [AssertionBuilder.Component]()
            for sectionIndex in (0..<viewModel.numberOfComponents) {
                let visitor = Visitor()
                var component = AssertionBuilder.Component(title: viewModel.titleForComponent(at: sectionIndex), components: [])
                for itemIndex in (0..<viewModel.numberOfItemsInComponent(at: sectionIndex)) {
                    let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                    viewModel.describeComponent(at: indexPath, to: visitor)
                }
                
                component.components = visitor.components
                actual.append(component)
            }
            
            return actual
        }
        
        private func verify(expected: AssertionBuilder.Component, actual: AssertionBuilder.Component, index: Int) {
            guard expected.title == actual.title else {
                XCTFail("Component at index \(index) should have had title \"\(expected.title)\", but got \"\(actual.title)\"",
                    file: file,
                    line: line)
                return
            }
            
            guard expected.components.count == actual.components.count else {
                XCTFail("Expected component at index \(index) to have \(expected.components.count) components, but got \(actual.components.count)",
                    file: file,
                    line: line)
                return
            }
            
            for (idx, expectedComponent) in expected.components.enumerated() {
                let actualComponent = actual.components[idx]
                guard expectedComponent == actualComponent else {
                    XCTFail("Components at \(index)-\(idx) not equal: expected \(expectedComponent); got \(actualComponent)",
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
    
    func verifyModel(at indexPath: IndexPath, is expected: NewsViewModelValue, file: StaticString = #file, line: UInt = #line) {
        if let visitor = traverseViewModel() {
            guard let actual = visitor.moduleModels[indexPath] else {
                XCTFail("Did not resolve a module model at index path \(indexPath)", file: file, line: line)
                return
            }
            
            XCTAssertEqual(expected, actual, file: file, line: line)
        }
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
