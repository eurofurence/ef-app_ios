import UIKit

class KnowledgeListEntryTableViewCell: UITableViewCell, KnowledgeGroupEntryScene {

    // MARK: KnowledgeGroupEntryScene

    func setKnowledgeEntryTitle(_ title: String) {
        textLabel?.text = title
    }

}
