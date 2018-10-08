//
//  StubKnowledgeDetailSceneInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation
import RandomDataGeneration

struct StubKnowledgeEntryDetailViewModel: KnowledgeEntryDetailViewModel {
    
    var title: String
    var contents: NSAttributedString
    var links: [LinkViewModel]
    var images: [KnowledgeEntryImageViewModel]
    
    var modelLinks: [Link]
    
    func link(at index: Int) -> Link {
        return modelLinks[index]
    }
    
}

extension StubKnowledgeEntryDetailViewModel: RandomValueProviding {
    
    static var random: StubKnowledgeEntryDetailViewModel {
        let linkModels = [Link].random
        let linkViewModels: [LinkViewModel] = .random(upperLimit: linkModels.count)
        return StubKnowledgeEntryDetailViewModel(title: .random,
                                                 contents: .random,
                                                 links: linkViewModels,
                                                 images: .random,
                                                 modelLinks: linkModels)
    }
    
    static var randomWithoutLinks: StubKnowledgeEntryDetailViewModel {
        var viewModel = random
        viewModel.links = []
        viewModel.modelLinks = []
        
        return viewModel
    }
    
}

extension LinkViewModel: RandomValueProviding {
    
    public static var random: LinkViewModel {
        return LinkViewModel(name: .random)
    }
    
}

extension KnowledgeEntryImageViewModel: RandomValueProviding {
    
    public static var random: KnowledgeEntryImageViewModel {
        return KnowledgeEntryImageViewModel(imagePNGData: .random)
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
