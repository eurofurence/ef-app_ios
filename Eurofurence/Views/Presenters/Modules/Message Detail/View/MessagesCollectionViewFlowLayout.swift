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

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        attributes.forEach(updateItemOffset)
        attributes.forEach(updateItemSize)

        return attributes
    }

    private func updateItemOffset(of attributes: UICollectionViewLayoutAttributes) {
        guard let collectionView = collectionView else { return }

        var frame = attributes.frame
        if #available(iOS 11.0, *) {
            frame.origin.x = collectionView.safeAreaInsets.left + tipInset
        } else {
            frame.origin.x = tipInset
        }

        attributes.frame = frame
    }

    private func updateItemSize(of attributes: UICollectionViewLayoutAttributes) {
        guard let collectionView = collectionView else { return }

        attributes.frame.size.width = max(collectionView.frame.width * 0.66, 160)
    }

}
