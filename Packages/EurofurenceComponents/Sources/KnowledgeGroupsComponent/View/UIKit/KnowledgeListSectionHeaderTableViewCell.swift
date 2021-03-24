import UIKit

class KnowledgeListSectionHeaderTableViewCell: UITableViewCell, KnowledgeGroupScene {

    // MARK: IBOutlets

    @IBOutlet private weak var knowledgeGroupTitleLabel: UILabel!
    @IBOutlet private weak var fontAwesomeCharacterLabel: UILabel!
    @IBOutlet private weak var knowledgeGroupDescriptionLabel: UILabel!

    // MARK: KnowledgeGroupHeaderScene

    func setKnowledgeGroupTitle(_ title: String) {
        knowledgeGroupTitleLabel.text = title
    }

    func setKnowledgeGroupFontAwesomeCharacter(_ character: Character) {
        fontAwesomeCharacterLabel.text = String(character)
    }

    func setKnowledgeGroupDescription(_ groupDescription: String) {
        knowledgeGroupDescriptionLabel.text = groupDescription
    }

}
