import UIKit

class EventFeedbackViewController: UITableViewController, EventFeedbackScene {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventSubheadingLabel: UILabel!
    @IBOutlet weak var feedbackTextView: UITextView!

    @IBAction func cancelFeedback(_ sender: Any) {
        
    }
    
    @IBAction func submitFeedback(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.eventFeedbackSceneDidLoad()
    }
    
    private var delegate: EventFeedbackSceneDelegate?
    func setDelegate(_ delegate: EventFeedbackSceneDelegate) {
        self.delegate = delegate
    }
    
    func bind(_ viewModel: EventFeedbackViewModel) {
        eventTitleLabel.text = viewModel.eventTitle
        eventSubheadingLabel.text = [viewModel.eventDayAndTime, viewModel.eventLocation, viewModel.eventHosts].joined(separator: "\n")
    }
    
}
