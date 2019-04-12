import UIKit

struct ApplicationAppStateProviding: AppStateProviding {

    var isAppActive: Bool {
        return UIApplication.shared.applicationState == .active
    }

}
