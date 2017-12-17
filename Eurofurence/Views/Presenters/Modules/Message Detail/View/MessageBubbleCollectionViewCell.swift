//
//  MessageBubbleCollectionViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UICollectionViewCell

class MessageBubbleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bubbleBackgroundView: MessageBubbleBackgroundView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let width = attributes.frame.width
        let targetSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let height = systemLayoutSizeFitting(targetSize).height

        var frame = attributes.frame
        frame.size = CGSize(width: width, height: height)
        attributes.frame = frame

        return attributes
    }

}
