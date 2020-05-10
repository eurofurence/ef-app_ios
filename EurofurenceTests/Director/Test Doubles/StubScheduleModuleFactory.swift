@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubScheduleModuleFactory: ScheduleComponentFactory {

    let stubInterface = FakeViewController()
    fileprivate var delegate: ScheduleComponentDelegate?
    func makeScheduleComponent(_ delegate: ScheduleComponentDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubScheduleModuleFactory {

    func simulateDidSelectEvent(_ identifier: EventIdentifier) {
        delegate?.scheduleComponentDidSelectEvent(identifier: identifier)
    }

}
