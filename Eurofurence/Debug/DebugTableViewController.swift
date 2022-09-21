import FirebaseMessaging
import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

class DebugTableViewController: UITableViewController {

    // MARK: Properties

    @IBOutlet private weak var fcmTokenLabel: UILabel!
    
    private lazy var actions: [IndexPath: () -> Void] = [
        IndexPath(item: 0, section: 0): self.copyFCMToPasteBoard
    ]

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpFCMCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actions[indexPath]?()
    }

    @IBAction private func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: FCM
    
    private func setUpFCMCell() {
        guard let value = Messaging.messaging().fcmToken else { return }
        fcmTokenLabel.text = value
    }

    private func copyFCMToPasteBoard() {
        guard let value = Messaging.messaging().fcmToken else { return }
        UIPasteboard.general.setValue(value, forPasteboardType: UTType.plainText.identifier)

        let alert = UIAlertController(title: "FCM Copied", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
}
