@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import TestUtilities

final class StubKnowledgeEntryDetailViewModel: KnowledgeEntryDetailViewModel {

    var title: String
    var contents: NSAttributedString
    var links: [LinkViewModel]
    var images: [KnowledgeEntryImageViewModel]

    var modelLinks: [Link]

    init(title: String,
         contents: NSAttributedString,
         links: [LinkViewModel],
         images: [KnowledgeEntryImageViewModel],
         modelLinks: [Link]) {
        self.title = title
        self.contents = contents
        self.links = links
        self.images = images
        self.modelLinks = modelLinks
    }

    func link(at index: Int) -> Link {
        return modelLinks[index]
    }
    
    private(set) var shareSender: AnyObject?
    func shareKnowledgeEntry(_ sender: AnyObject) {
        shareSender = sender
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
        let viewModel = random
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
    func makeViewModel(for entry: KnowledgeEntryIdentifier, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void) {
        completionHandler(viewModel)
    }

}
