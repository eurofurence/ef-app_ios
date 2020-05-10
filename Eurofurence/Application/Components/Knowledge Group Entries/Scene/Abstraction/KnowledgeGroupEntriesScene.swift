import Foundation

protocol KnowledgeGroupEntriesScene {

    func setDelegate(_ delegate: KnowledgeGroupEntriesSceneDelegate)
    func setKnowledgeGroupTitle(_ title: String)
    func bind(numberOfEntries: Int, using binder: KnowledgeGroupEntriesBinder)

}

protocol KnowledgeGroupEntriesSceneDelegate {

    func knowledgeGroupEntriesSceneDidLoad()
    func knowledgeGroupEntriesSceneDidSelectEntry(at index: Int)

}
