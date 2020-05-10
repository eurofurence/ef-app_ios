import UIKit

struct MapsContentControllerFactory: ApplicationModuleFactory {
    
    var mapsModuleProviding: MapsModuleProviding
    var mapsModuleDelegate: MapsModuleDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        mapsModuleProviding.makeMapsModule(mapsModuleDelegate)
    }
    
}
