import EurofurenceModel
import UIKit

public class ApplicationSignificantTimeChangeAdapter: SignificantTimeChangeAdapter {

    private var notificationRegistration: NSObjectProtocol?

    public init() {
        notificationRegistration = NotificationCenter.default.addObserver(forName: UIApplication.significantTimeChangeNotification, object: nil, queue: .main) { (_) in
            self.delegate?.significantTimeChangeDidOccur()
        }
    }

    private var delegate: SignificantTimeChangeAdapterDelegate?
    public func setDelegate(_ delegate: SignificantTimeChangeAdapterDelegate) {
        self.delegate = delegate
    }

}
