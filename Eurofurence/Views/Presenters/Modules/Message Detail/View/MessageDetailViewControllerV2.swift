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
        collectionView.layoutSubviews()
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return messageCell!
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
