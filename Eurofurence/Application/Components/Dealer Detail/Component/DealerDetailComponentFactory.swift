import EurofurenceModel
import UIKit

public protocol DealerDetailComponentFactory {

    func makeDealerDetailComponent(for dealer: DealerIdentifier) -> UIViewController

}
