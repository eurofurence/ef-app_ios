//
//  AspectRatioConstrainedImageView.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class AspectRatioConstrainedImageView: UIImageView {

    override var image: UIImage? {
        didSet {
            if let size = image?.size {
                applyAspectRatioImageConstraints(size: size)
            }
        }
    }

    private func applyAspectRatioImageConstraints(size: CGSize) {
        let aspectRatio = size.width / size.height
        let aspectRatioConstraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
        aspectRatioConstraint.priority = UILayoutPriority(999)
        aspectRatioConstraint.isActive = true
    }

}
