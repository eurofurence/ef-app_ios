import UIKit

public protocol PresentationAssets {

    var initialLoadInformationAsset: UIImage { get }

}

struct ApplicationPresentationAssets: PresentationAssets {

    let initialLoadInformationAsset: UIImage = UIImage(
        systemName: "info.circle"
    ).unsafelyUnwrapped

}
