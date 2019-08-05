import EurofurenceModel
import Foundation

struct DefaultKnowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor {

    private struct ViewModel: KnowledgeEntryDetailViewModel {
        
        var title: String
        var contents: NSAttributedString
        var links: [LinkViewModel]
        var images: [KnowledgeEntryImageViewModel]
        
        private var linkModels: [Link]
        private let entry: KnowledgeEntry
        private let shareService: ShareService

        init(entry: KnowledgeEntry, contents: NSAttributedString, images: [Data], shareService: ShareService) {
            self.entry = entry
            self.title = entry.title
            self.contents = contents
            self.linkModels = entry.links
            self.shareService = shareService
            self.links = entry.links.map({ LinkViewModel(name: $0.name) })
            self.images = images.map(KnowledgeEntryImageViewModel.init)
        }

        func link(at index: Int) -> Link {
            return linkModels[index]
        }
        
        func shareKnowledgeEntry(_ sender: AnyObject) {
            let contentURL = entry.makeContentURL()
            shareService.share(contentURL, sender: sender)
        }

    }

    var knowledgeService: KnowledgeService
    var renderer: MarkdownRenderer
    var shareService: ShareService

    func makeViewModel(for identifier: KnowledgeEntryIdentifier, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void) {
        let service = knowledgeService
        service.fetchKnowledgeEntry(for: identifier) { (entry) in
            service.fetchImagesForKnowledgeEntry(identifier: identifier) { (images) in
                let renderedContents = self.renderer.render(entry.contents)
                let viewModel = ViewModel(entry: entry, contents: renderedContents, images: images, shareService: self.shareService)
                completionHandler(viewModel)
            }
        }
    }

}
