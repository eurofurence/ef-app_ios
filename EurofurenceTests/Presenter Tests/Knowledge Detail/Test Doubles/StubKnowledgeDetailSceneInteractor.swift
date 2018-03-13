//
//  StubKnowledgeDetailSceneInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension KnowledgeEntryDetailViewModel: RandomValueProviding {
    
    static var random: KnowledgeEntryDetailViewModel {
        return KnowledgeEntryDetailViewModel(contents: .random)
    }
    
}

extension NSAttributedString {
    
    static var random: NSAttributedString {
        return NSAttributedString(string: .random)
    }
    
}

class StubKnowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor {
    
    let viewModel = KnowledgeEntryDetailViewModel.random
    func makeViewModel(for entry: KnowledgeEntry2) -> KnowledgeEntryDetailViewModel {
        return viewModel
    }
    
}
