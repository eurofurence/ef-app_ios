import UIKit

class EventFeedbackSuccessViewController: UIViewController {
    
    @IBOutlet private weak var tickImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tickImageView.tintColor = .eurofurenceGreen
    }

}
