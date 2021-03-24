import EurofurenceModel
import EventDetailComponent
import UIKit
import XCTEurofurenceModel

public class StubEventDetailComponentFactory: EventDetailComponentFactory {
    
    public init() {
        
    }

    public let stubInterface = UIViewController()
    public private(set) var capturedModel: EventIdentifier?
    private var delegate: EventDetailComponentDelegate?
    public func makeEventDetailComponent(
        for event: EventIdentifier, 
        delegate: EventDetailComponentDelegate
    ) -> UIViewController {
        capturedModel = event
        self.delegate = delegate
        
        return stubInterface
    }
    
    public func simulateLeaveFeedback() {
        guard let capturedModel = capturedModel else { return }
        delegate?.eventDetailComponentDidRequestPresentationToLeaveFeedback(for: capturedModel)
    }

}
