@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubScheduleModuleFactory: ScheduleModuleProviding {

    let stubInterface = FakeViewController()
    fileprivate var delegate: ScheduleModuleDelegate?
    func makeScheduleModule(_ delegate: ScheduleModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubScheduleModuleFactory {

    func simulateDidSelectEvent(_ identifier: EventIdentifier) {
        delegate?.scheduleModuleDidSelectEvent(identifier: identifier)
    }

}
