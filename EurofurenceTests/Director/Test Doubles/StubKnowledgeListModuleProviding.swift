//
//  StubKnowledgeListModuleProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubKnowledgeListModuleProviding: KnowledgeListModuleProviding {
    
    let stubInterface = FakeViewController()
    private(set) var delegate: KnowledgeListModuleDelegate?
    func makeKnowledgeListModule(_ delegate: KnowledgeListModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

extension StubKnowledgeListModuleProviding {
    
    func simulateKnowledgeEntrySelected(_ entry: KnowledgeEntry2) {
        delegate?.knowledgeListModuleDidSelectKnowledgeEntry(entry)
    }
    
}
