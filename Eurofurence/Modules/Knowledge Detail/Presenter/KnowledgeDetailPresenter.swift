import EurofurenceModel

class KnowledgeDetailPresenter: KnowledgeDetailSceneDelegate {

    private let delegate: KnowledgeDetailModuleDelegate
    private let knowledgeDetailScene: KnowledgeDetailScene
    private let identifier: KnowledgeEntryIdentifier
    private let knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor
    private var viewModel: KnowledgeEntryDetailViewModel?

    init(delegate: KnowledgeDetailModuleDelegate,
         knowledgeDetailScene: KnowledgeDetailScene,
         identifier: KnowledgeEntryIdentifier,
         knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor) {
        self.delegate = delegate
        self.knowledgeDetailScene = knowledgeDetailScene
        self.identifier = identifier
        self.knowledgeDetailSceneInteractor = knowledgeDetailSceneInteractor

        knowledgeDetailScene.setKnowledgeDetailSceneDelegate(self)
    }

    func knowledgeDetailSceneDidLoad() {
        knowledgeDetailSceneInteractor.makeViewModel(for: identifier, completionHandler: knowledgeDetailViewModelPrepared)
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

    private struct ViewModelImagesBinder: KnowledgentryImagesBinder {

        var viewModels: [KnowledgeEntryImageViewModel]

        func bind(_ scene: KnowledgeEntryImageScene, at index: Int) {
            let viewModel = viewModels[index]
            scene.showImagePNGData(viewModel.imagePNGData)
        }

    }

    private struct ViewModelLinksBinder: LinksBinder {

        var delegate: KnowledgeDetailModuleDelegate
        var viewModel: KnowledgeEntryDetailViewModel
        var viewModels: [LinkViewModel]

        func bind(_ scene: LinkScene, at index: Int) {
            let viewModel = viewModels[index]
            scene.setLinkName(viewModel.name)
            scene.setTapHandler {
                let link = self.viewModel.link(at: index)
                self.delegate.knowledgeDetailModuleDidSelectLink(link)
            }
        }

    }

}
