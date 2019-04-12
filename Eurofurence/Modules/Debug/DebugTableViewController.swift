import MobileCoreServices
import FirebaseMessaging
import UIKit

class DebugTableViewController: UITableViewController {

    // MARK: Properties

    @IBOutlet weak var fcmTokenLabel: UILabel!
    private lazy var actions: [IndexPath : () -> Void] = [
        IndexPath(item: 0, section: 0): self.copyFCMToPasteBoard
    ]

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let value = Messaging.messaging().fcmToken else { return }
        fcmTokenLabel.text = value
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actions[indexPath]?()
    }

    // MARK: Functions

    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    private func copyFCMToPasteBoard() {
        guard let value = Messaging.messaging().fcmToken else { return }
        UIPasteboard.general.setValue(value, forPasteboardType: kUTTypeRTF as String)

        let alert = UIAlertController(title: "FCM Copied", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }

}
