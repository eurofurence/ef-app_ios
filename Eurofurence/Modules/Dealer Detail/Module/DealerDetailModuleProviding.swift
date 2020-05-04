import EurofurenceModel
import UIKit

public protocol DealerDetailModuleProviding {

    func makeDealerDetailModule(for dealer: DealerIdentifier) -> UIViewController

}
