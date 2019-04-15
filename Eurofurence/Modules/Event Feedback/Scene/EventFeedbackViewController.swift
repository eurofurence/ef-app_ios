import UIKit

class EventFeedbackViewController: UITableViewController, UITextViewDelegate, EventFeedbackScene {
    
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventSubheadingLabel: UILabel!
    @IBOutlet private weak var feedbackTextView: UITextView!

    @IBAction func cancelFeedback(_ sender: Any) {
        
    }
    
    @IBAction func submitFeedback(_ sender: Any) {
        viewModel?.submitFeedback()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackTextView.delegate = self
        delegate?.eventFeedbackSceneDidLoad()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel?.feedbackChanged(textView.text)
    }
    
    private var delegate: EventFeedbackSceneDelegate?
    func setDelegate(_ delegate: EventFeedbackSceneDelegate) {
        self.delegate = delegate
    }
    
    private var viewModel: EventFeedbackViewModel?
    func bind(_ viewModel: EventFeedbackViewModel) {
        self.viewModel = viewModel
        
        eventTitleLabel.text = viewModel.eventTitle
        eventSubheadingLabel.text = [viewModel.eventDayAndTime, viewModel.eventLocation, viewModel.eventHosts].joined(separator: "\n")
    }
    
    func showFeedbackSubmissionSuccessful() {
        
    }
    
    func showFeedbackSubmissionFailedPrompt() {
        
    }
    
}
