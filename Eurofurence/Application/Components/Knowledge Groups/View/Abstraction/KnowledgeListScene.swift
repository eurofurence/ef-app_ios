import Foundation.NSIndexPath

protocol KnowledgeListScene {

    func setDelegate(_ delegate: KnowledgeListSceneDelegate)
    func setKnowledgeListTitle(_ title: String)
    func setKnowledgeListShortTitle(_ shortTitle: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func prepareToDisplayKnowledgeGroups(numberOfGroups: Int, binder: KnowledgeListBinder)
    func deselectKnowledgeEntry(at indexPath: IndexPath)

}
