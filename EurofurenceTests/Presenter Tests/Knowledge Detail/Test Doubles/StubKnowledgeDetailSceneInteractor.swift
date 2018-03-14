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
        return KnowledgeEntryDetailViewModel(contents: .random, links: .random)
    }
    
    static var randomWithoutLinks: KnowledgeEntryDetailViewModel {
        var viewModel = random
        viewModel.links = []
        
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
    
    var viewModel = KnowledgeEntryDetailViewModel.random
    func makeViewModel(for entry: KnowledgeEntry2) -> KnowledgeEntryDetailViewModel {
        return viewModel
    }
    
    fileprivate var stubbedLinks = [Int : Link]()
    func link(at index: Int) -> Link {
        return stubbedLinks[index] ?? .random
    }
    
}

extension StubKnowledgeDetailSceneInteractor {
    
    func stub(_ link: Link, at index: Int) {
        stubbedLinks[index] = link
    }
    
}
