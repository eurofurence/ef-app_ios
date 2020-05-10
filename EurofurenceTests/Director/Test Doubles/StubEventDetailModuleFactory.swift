@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class StubEventDetailModuleFactory: EventDetailComponentFactory {

    let stubInterface = UIViewController()
    private(set) var capturedModel: EventIdentifier?
    private var delegate: EventDetailComponentDelegate?
    func makeEventDetailComponent(for event: EventIdentifier, delegate: EventDetailComponentDelegate) -> UIViewController {
        capturedModel = event
        self.delegate = delegate
        
        return stubInterface
    }
    
    func simulateLeaveFeedback() {
        guard let capturedModel = capturedModel else { return }
        delegate?.eventDetailComponentDidRequestPresentationToLeaveFeedback(for: capturedModel)
    }

}
