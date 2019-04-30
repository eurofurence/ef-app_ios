import UIKit

class EventFeedbackFormViewController: UITableViewController, UITextViewDelegate {
    
    var viewModel: EventFeedbackViewModel?

    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var starRatingControl: StarRatingControl!
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        viewModel?.feedbackChanged(textView.text)
    }
    
    @IBAction func starRatingValueDidChange(_ sender: Any) {
        let percentage = starRatingControl.percentageValue
        viewModel?.ratingPercentageChanged(percentage)
    }
    
}
