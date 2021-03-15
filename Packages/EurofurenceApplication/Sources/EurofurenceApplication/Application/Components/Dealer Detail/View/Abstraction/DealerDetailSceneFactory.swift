import UIKit

public protocol DealerDetailSceneFactory {

    func makeDealerDetailScene() -> UIViewController & DealerDetailScene

}
