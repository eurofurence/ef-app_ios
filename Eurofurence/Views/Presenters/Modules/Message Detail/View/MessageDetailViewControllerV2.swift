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
    private var binders = [CellBinder]()

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.messageDetailSceneDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.layoutSubviews()
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return binders.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return binders.first!.makeCell(from: collectionView, forItemAt: indexPath)
    }

    // MARK: MessageDetailScene

    var delegate: MessageDetailSceneDelegate?

    func setMessageDetailTitle(_ title: String) {
        super.title = title
    }

    func addMessageComponent(with binder: MessageComponentBinder) {
        binders.append(CellBinder(binder: binder))
        collectionView.reloadData()
    }

    // MARK: Binding

    private struct CellBinder {

        var binder: MessageComponentBinder

        func makeCell(from collectionView: UICollectionView, forItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageBubbleCollectionViewCell
            binder.bind(cell, toMessageAt: 0)

            return cell
        }

    }

}
