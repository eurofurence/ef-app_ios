import UIKit

class KnowledgeDetailContentsTableViewCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet private var textView: UITextView!
    
    // MARK: Functions
    
    func configure(_ attributedText: NSAttributedString) {
        textView.attributedText = attributedText
    }

}
