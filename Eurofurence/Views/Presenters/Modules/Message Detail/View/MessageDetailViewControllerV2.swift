//
//  MessageDetailViewControllerV2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class MessageDetailViewControllerV2: UIViewController,
                                     UICollectionViewDataSource,
                                     UICollectionViewDelegateFlowLayout,
                                     MessageDetailScene {

    // MARK: IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    private var messageCell: MessageBubbleCollectionViewCell?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        messageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: IndexPath(item: 0, section: 0)) as? MessageBubbleCollectionViewCell
        collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        delegate?.messageDetailSceneWillAppear()

        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutSubviews()
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return messageCell!
    }

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let messageCell = messageCell else { return .zero }
        guard let attributes = collectionViewLayout.layoutAttributesForItem(at: indexPath) else { return .zero }

        let width = attributes.frame.width
        let targetSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let height = messageCell.systemLayoutSizeFitting(targetSize).height

        return CGSize(width: width, height: height)
    }

    // MARK: MessageDetailScene

    var delegate: MessageDetailSceneDelegate?

    func setMessageDetailTitle(_ title: String) {
        super.title = title
    }

    func setMessageSubject(_ subject: String) {
        messageCell?.subjectLabel.text = subject
    }

    func setMessageContents(_ contents: String) {
        messageCell?.messageLabel.text = contents
    }

}
