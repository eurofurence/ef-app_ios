import UIKit

public protocol PresentationAssets {

    var initialLoadInformationAsset: UIImage { get }

}

struct ApplicationPresentationAssets: PresentationAssets {

    let initialLoadInformationAsset: UIImage = {
        guard let icon = UIImage(named: "tuto02_informationIcon", in: .module, compatibleWith: nil) else {
            fatalError("Missing icon from bundle")
        }
        
        return icon
    }()

}
