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

    // MARK: Overrides

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.messageDetailSceneWillAppear()
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    // MARK: MessageDetailScene

    var delegate: MessageDetailSceneDelegate?

    func setMessageDetailTitle(_ title: String) {
        super.title = title
    }

    func setMessageSubject(_ subject: String) {

    }

    func setMessageContents(_ contents: String) {

    }

}
