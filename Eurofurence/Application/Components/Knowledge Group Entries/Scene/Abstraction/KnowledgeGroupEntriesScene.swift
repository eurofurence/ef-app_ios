import Foundation

public protocol KnowledgeGroupEntriesScene {

    func setDelegate(_ delegate: KnowledgeGroupEntriesSceneDelegate)
    func setKnowledgeGroupTitle(_ title: String)
    func bind(numberOfEntries: Int, using binder: KnowledgeGroupEntriesBinder)

}

public protocol KnowledgeGroupEntriesSceneDelegate {

    func knowledgeGroupEntriesSceneDidLoad()
    func knowledgeGroupEntriesSceneDidSelectEntry(at index: Int)

}
