//
//  AspectRatioConstrainedImageView.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class AspectRatioConstrainedImageView: UIImageView {

    private var aspectRatioConstraint: NSLayoutConstraint?

    override var image: UIImage? {
        didSet {
            aspectRatioConstraint.let(removeConstraint)
            aspectRatioConstraint = nil

            image.let { (image) in
                let size = image.size
                let constraint = NSLayoutConstraint(item: self,
                                                    attribute: .width,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .height,
                                                    multiplier: size.width / size.height,
                                                    constant: 0)
                addConstraint(constraint)
                aspectRatioConstraint = constraint
            }
        }
    }

}
