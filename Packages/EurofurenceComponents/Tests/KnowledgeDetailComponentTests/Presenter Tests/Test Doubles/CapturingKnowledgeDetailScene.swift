import EurofurenceModel
import KnowledgeDetailComponent
import UIKit.UIViewController

class CapturingKnowledgeDetailScene: UIViewController, KnowledgeDetailScene {

    fileprivate var delegate: KnowledgeDetailSceneDelegate?
    func setKnowledgeDetailSceneDelegate(_ delegate: KnowledgeDetailSceneDelegate) {
        self.delegate = delegate
    }

    private(set) var capturedTitle: String?
    func setKnowledgeDetailTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedKnowledgeAttributedText: NSAttributedString?
    func setAttributedKnowledgeEntryContents(_ contents: NSAttributedString) {
        capturedKnowledgeAttributedText = contents
    }

    private(set) var linksToPresent: Int?
    private(set) var linksBinder: LinksBinder?
    func presentLinks(count: Int, using binder: LinksBinder) {
        linksToPresent = count
        linksBinder = binder
    }

    private(set) var boundImagesCount: Int?
    private(set) var imagesBinder: KnowledgEntryImagesBinder?
    func bindImages(count: Int, using binder: KnowledgEntryImagesBinder) {
        boundImagesCount = count
        imagesBinder = binder
    }

}

extension CapturingKnowledgeDetailScene {

    func simulateSceneDidLoad() {
        delegate?.knowledgeDetailSceneDidLoad()
    }
    
    func simulateShareButtonTapped(_ sender: AnyObject) {
        delegate?.knowledgeDetailSceneShareButtonTapped(sender)
    }

}
