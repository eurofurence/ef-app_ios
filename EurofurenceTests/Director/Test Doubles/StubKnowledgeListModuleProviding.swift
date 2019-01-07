//
//  StubKnowledgeGroupsListModuleProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubKnowledgeGroupsListModuleProviding: KnowledgeGroupsListModuleProviding {

    let stubInterface = FakeViewController()
    private(set) var delegate: KnowledgeGroupsListModuleDelegate?
    func makeKnowledgeListModule(_ delegate: KnowledgeGroupsListModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubKnowledgeGroupsListModuleProviding {

    func simulateKnowledgeGroupSelected(_ group: KnowledgeGroupIdentifier) {
        delegate?.knowledgeListModuleDidSelectKnowledgeGroup(group)
    }

}
