//
//  StubKnowledgeDetailSceneInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct StubKnowledgeEntryDetailViewModel: KnowledgeEntryDetailViewModel {
    
    var contents: NSAttributedString
    var links: [LinkViewModel]
    
    var modelLinks: [Link]
    
    func link(at index: Int) -> Link {
        return modelLinks[index]
    }
    
}

extension StubKnowledgeEntryDetailViewModel: RandomValueProviding {
    
    static var random: StubKnowledgeEntryDetailViewModel {
        let linkViewModels: [LinkViewModel] = .random
        return StubKnowledgeEntryDetailViewModel(contents: .random,
                                                 links: linkViewModels,
                                                 modelLinks: .random(upperLimit: linkViewModels.count))
    }
    
    static var randomWithoutLinks: StubKnowledgeEntryDetailViewModel {
        var viewModel = random
        viewModel.links = []
        viewModel.modelLinks = []
        
        return viewModel
    }
    
}

extension LinkViewModel: RandomValueProviding {
    
    static var random: LinkViewModel {
        return LinkViewModel(name: .random)
    }
    
}

extension NSAttributedString {
    
    static var random: NSAttributedString {
        return NSAttributedString(string: .random)
    }
    
}

class StubKnowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor {
    
    var viewModel = StubKnowledgeEntryDetailViewModel.random
    func makeViewModel(for entry: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void) {
        completionHandler(viewModel)
    }
    
}
