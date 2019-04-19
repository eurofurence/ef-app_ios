@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class StubEventDetailModuleFactory: EventDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedModel: EventIdentifier?
    private var delegate: EventDetailModuleDelegate?
    func makeEventDetailModule(for event: EventIdentifier, delegate: EventDetailModuleDelegate) -> UIViewController {
        capturedModel = event
        self.delegate = delegate
        
        return stubInterface
    }
    
    func simulateLeaveFeedback() {
        guard let capturedModel = capturedModel else { return }
        delegate?.eventDetailModuleDidRequestPresentationToLeaveFeedback(for: capturedModel)
    }

}
