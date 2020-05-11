import Foundation

public protocol KnowledgeDetailScene {

    func setKnowledgeDetailSceneDelegate(_ delegate: KnowledgeDetailSceneDelegate)
    func setKnowledgeDetailTitle(_ title: String)
    func setAttributedKnowledgeEntryContents(_ contents: NSAttributedString)
    func presentLinks(count: Int, using binder: LinksBinder)
    func bindImages(count: Int, using binder: KnowledgEntryImagesBinder)

}

public protocol KnowledgeDetailSceneDelegate {

    func knowledgeDetailSceneDidLoad()
    func knowledgeDetailSceneShareButtonTapped(_ sender: AnyObject)

}
