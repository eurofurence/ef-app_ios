//
//  StubNewsViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import Foundation.NSIndexPath

struct StubNewsViewModel: NewsViewModel {

    struct Component {

        var title: String
        var numberOfItems: Int

    }

    var components: [Component]

    var numberOfComponents: Int {
        return components.count
    }

    func numberOfItemsInComponent(at index: Int) -> Int {
        return components[index].numberOfItems
    }

    func titleForComponent(at index: Int) -> String {
        return components[index].title
    }

    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {

    }

    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {

    }

}
