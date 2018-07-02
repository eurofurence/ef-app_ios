//
//  WhenBindingAllAnnouncementsComponent_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class ViewAllAnnouncementsViewModel: NewsViewModel {
    
    private let component: ViewAllAnnouncementsComponentViewModel
    
    init(component: ViewAllAnnouncementsComponentViewModel) {
        self.component = component
    }
    
    var numberOfComponents: Int {
        return 1
    }
    
    func numberOfItemsInComponent(at index: Int) -> Int {
        return 1
    }
    
    func titleForComponent(at index: Int) -> String {
        return "All Announcements"
    }
    
    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        visitor.visit(component)
    }
    
    private var models = [IndexPath : NewsViewModelValue]()
    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {
        if let model = models[indexPath] {
            completionHandler(model)
        }
    }
    
}

class WhenBindingAllAnnouncementsComponent_NewsPresenterShould: XCTestCase {
    
    func testBindTheCaptionOntoTheComponent() {
        let component = ViewAllAnnouncementsComponentViewModel(caption: .random)
        let viewModel = ViewAllAnnouncementsViewModel(component: component)
        let indexPath = IndexPath(row: 0, section: 0)
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
        
        XCTAssertEqual(component.caption, context.newsScene.stubbedAllAnnouncementsComponent.capturedCaption)
    }
    
}
