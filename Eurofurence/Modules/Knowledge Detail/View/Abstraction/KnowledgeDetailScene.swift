import Foundation

protocol KnowledgeDetailScene {

    func setKnowledgeDetailSceneDelegate(_ delegate: KnowledgeDetailSceneDelegate)
    func setKnowledgeDetailTitle(_ title: String)
    func setAttributedKnowledgeEntryContents(_ contents: NSAttributedString)
    func presentLinks(count: Int, using binder: LinksBinder)
    func bindImages(count: Int, using binder: KnowledgentryImagesBinder)

}

protocol KnowledgeDetailSceneDelegate {

    func knowledgeDetailSceneDidLoad()
    func knowledgeDetailSceneDidSelectLink(at index: Int)

}
