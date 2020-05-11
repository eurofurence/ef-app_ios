import EurofurenceModel

class KnowledgeDetailPresenter: KnowledgeDetailSceneDelegate {

    private let delegate: KnowledgeDetailComponentDelegate
    private let knowledgeDetailScene: KnowledgeDetailScene
    private let identifier: KnowledgeEntryIdentifier
    private let knowledgeDetailViewModelFactory: KnowledgeDetailViewModelFactory
    private var viewModel: KnowledgeEntryDetailViewModel?

    init(delegate: KnowledgeDetailComponentDelegate,
         knowledgeDetailScene: KnowledgeDetailScene,
         identifier: KnowledgeEntryIdentifier,
         knowledgeDetailViewModelFactory: KnowledgeDetailViewModelFactory) {
        self.delegate = delegate
        self.knowledgeDetailScene = knowledgeDetailScene
        self.identifier = identifier
        self.knowledgeDetailViewModelFactory = knowledgeDetailViewModelFactory

        knowledgeDetailScene.setKnowledgeDetailSceneDelegate(self)
    }

    func knowledgeDetailSceneDidLoad() {
        knowledgeDetailViewModelFactory.makeViewModel(for: identifier, completionHandler: knowledgeDetailViewModelPrepared)
    }
    
    func knowledgeDetailSceneShareButtonTapped(_ sender: AnyObject) {
        viewModel?.shareKnowledgeEntry(sender)
    }

    private func knowledgeDetailViewModelPrepared(_ viewModel: KnowledgeEntryDetailViewModel) {
        self.viewModel = viewModel

        let images: [KnowledgeEntryImageViewModel] = viewModel.images
        let imagesBinder = ViewModelImagesBinder(viewModels: images)
        knowledgeDetailScene.bindImages(count: images.count, using: imagesBinder)

        knowledgeDetailScene.setKnowledgeDetailTitle(viewModel.title)
        knowledgeDetailScene.setAttributedKnowledgeEntryContents(viewModel.contents)

        let links = viewModel.links

        if links.isEmpty == false {
            let binder = ViewModelLinksBinder(delegate: delegate, viewModel: viewModel, viewModels: links)
            knowledgeDetailScene.presentLinks(count: links.count, using: binder)
        }
    }

    private struct ViewModelImagesBinder: KnowledgEntryImagesBinder {

        var viewModels: [KnowledgeEntryImageViewModel]

        func bind(_ scene: KnowledgeEntryImageScene, at index: Int) {
            let viewModel = viewModels[index]
            scene.showImagePNGData(viewModel.imagePNGData)
        }

    }

    private struct ViewModelLinksBinder: LinksBinder {

        var delegate: KnowledgeDetailComponentDelegate
        var viewModel: KnowledgeEntryDetailViewModel
        var viewModels: [LinkViewModel]

        func bind(_ scene: LinkScene, at index: Int) {
            let viewModel = viewModels[index]
            scene.setLinkName(viewModel.name)
            scene.setTapHandler {
                let link = self.viewModel.link(at: index)
                self.delegate.knowledgeComponentModuleDidSelectLink(link)
            }
        }

    }

}
