import UIKit.UICollectionViewFlowLayout

class MessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private let tipInset: CGFloat = 14

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if #available(iOS 10.0, *) {
            estimatedItemSize = UICollectionViewFlowLayout.automaticSize
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
        frame.origin.x = collectionView.safeAreaInsets.left + tipInset

        let horizontalContentInsets = collectionView.contentInset.left - collectionView.contentInset.right
        let horizontalSectionInsets = sectionInset.left - sectionInset.right
        let availableWidth = collectionView.frame.width - horizontalContentInsets - horizontalSectionInsets
        frame.size.width = availableWidth * 0.66

        attributes.frame = frame
    }

}
