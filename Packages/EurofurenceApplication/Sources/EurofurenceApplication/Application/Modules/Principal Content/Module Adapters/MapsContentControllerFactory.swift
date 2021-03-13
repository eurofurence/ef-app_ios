import UIKit

struct MapsContentControllerFactory: ApplicationModuleFactory {
    
    var mapsComponentFactory: MapsComponentFactory
    var mapsComponentDelegate: MapsComponentDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        mapsComponentFactory.makeMapsModule(mapsComponentDelegate)
    }
    
}
