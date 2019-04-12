@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class StubEventDetailModuleFactory: EventDetailModuleProviding {

    private(set) var stubInterface: UIViewController?
    private(set) var capturedModel: EventIdentifier?
    func makeEventDetailModule(for event: EventIdentifier) -> UIViewController {
        stubInterface = UIViewController()
        capturedModel = event
        return stubInterface!
    }

}
