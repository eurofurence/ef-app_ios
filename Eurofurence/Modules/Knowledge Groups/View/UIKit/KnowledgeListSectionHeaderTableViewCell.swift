import UIKit

class KnowledgeListSectionHeaderTableViewCell: UITableViewCell, KnowledgeGroupScene {

    // MARK: IBOutlets

    @IBOutlet weak var knowledgeGroupTitleLabel: UILabel!
    @IBOutlet weak var fontAwesomeCharacterLabel: UILabel!
    @IBOutlet weak var knowledgeGroupDescriptionLabel: UILabel!

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
