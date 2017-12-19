//
//  MessagesCollectionViewFlowLayout.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UICollectionViewFlowLayout

class MessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private let tipInset: CGFloat = 14

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if #available(iOS 10.0, *) {
            estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        attributes.forEach(updateItemAttributesForMessageBubble)

        return attributes
    }

    private func updateItemAttributesForMessageBubble(_ attributes: UICollectionViewLayoutAttributes) {
        guard let collectionView = collectionView else { return }

        var frame = attributes.frame
        if #available(iOS 11.0, *) {
            frame.origin.x = collectionView.safeAreaInsets.left + tipInset
        } else {
            frame.origin.x = tipInset
        }

        let availableWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - sectionInset.left - sectionInset.right
        frame.size.width = availableWidth * 0.66

        attributes.frame = frame
    }

}
