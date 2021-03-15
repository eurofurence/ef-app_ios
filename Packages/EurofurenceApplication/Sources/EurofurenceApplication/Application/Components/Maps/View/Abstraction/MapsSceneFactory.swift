import UIKit

public protocol MapsSceneFactory {

    func makeMapsScene() -> UIViewController & MapsScene

}
