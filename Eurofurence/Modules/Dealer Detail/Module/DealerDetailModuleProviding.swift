import EurofurenceModel
import UIKit

protocol DealerDetailModuleProviding {

    func makeDealerDetailModule(for dealer: DealerIdentifier) -> UIViewController

}
