import UIKit

struct MapsContentControllerFactory: ContentControllerFactory {
    
    var mapsModuleProviding: MapsModuleProviding
    var mapsModuleDelegate: MapsModuleDelegate
    
    func makeContentController() -> UIViewController {
        mapsModuleProviding.makeMapsModule(mapsModuleDelegate)
    }
    
}
