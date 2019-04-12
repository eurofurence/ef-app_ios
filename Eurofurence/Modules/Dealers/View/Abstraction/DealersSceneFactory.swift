import UIKit.UIViewController

protocol DealersSceneFactory {

    func makeDealersScene() -> UIViewController & DealersScene

}
