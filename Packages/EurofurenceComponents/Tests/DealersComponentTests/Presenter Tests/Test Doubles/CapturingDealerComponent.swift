import DealersComponent
import EurofurenceModel
import Foundation

class CapturingDealerComponent: DealerComponent {

    private(set) var capturedDealerTitle: String?
    func setDealerTitle(_ title: String) {
        capturedDealerTitle = title
    }

    private(set) var capturedDealerSubtitle: String?
    func setDealerSubtitle(_ subtitle: String?) {
        capturedDealerSubtitle = subtitle
    }

    private(set) var capturedDealerPNGData: Data?
    func setDealerIconPNGData(_ pngData: Data) {
        capturedDealerPNGData = pngData
    }

    private(set) var didShowNotPresentOnAllDaysWarning = false
    func showNotPresentOnAllDaysWarning() {
        didShowNotPresentOnAllDaysWarning = true
    }

    private(set) var didHideNotPresentOnAllDaysWarning = false
    func hideNotPresentOnAllDaysWarning() {
        didHideNotPresentOnAllDaysWarning = true
    }

    private(set) var didShowAfterDarkContentWarning = false
    func showAfterDarkContentWarning() {
        didShowAfterDarkContentWarning = true
    }

    private(set) var didHideAfterDarkContentWarning = false
    func hideAfterDarkContentWarning() {
        didHideAfterDarkContentWarning = true
    }

}
