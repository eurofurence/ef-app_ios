import UIKit

protocol PresentationAssets {

    var initialLoadInformationAsset: UIImage { get }

}

struct ApplicationPresentationAssets: PresentationAssets {

    var initialLoadInformationAsset: UIImage = #imageLiteral(resourceName: "tuto02_informationIcon")

}
