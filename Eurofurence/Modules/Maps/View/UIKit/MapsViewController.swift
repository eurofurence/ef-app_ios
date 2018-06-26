//
//  MapsViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class MapsViewController: UIViewController, MapsScene {

    // MARK: Properties

    @IBOutlet weak var collectionView: UICollectionView!
    private var mapsController: MapsController? {
        didSet {
            collectionView.dataSource = mapsController
            collectionView.delegate = mapsController
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.mapsSceneDidLoad()
    }

    // MARK: MapsScene

    private var delegate: MapsSceneDelegate?
    func setDelegate(_ delegate: MapsSceneDelegate) {
        self.delegate = delegate
    }

    func setMapsTitle(_ title: String) {
        super.title = title
    }

    func bind(numberOfMaps: Int, using binder: MapsBinder) {
        mapsController = MapsController(numberOfMaps: numberOfMaps, binder: binder)
    }

    // MARK: Private

    private class MapsController: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        private let numberOfMaps: Int
        private let binder: MapsBinder

        init(numberOfMaps: Int, binder: MapsBinder) {
            self.numberOfMaps = numberOfMaps
            self.binder = binder
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return numberOfMaps
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeue(MapCollectionViewCell.self, for: indexPath)
            binder.bind(cell, at: indexPath.item)
            return cell
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = collectionView.bounds.width
            return CGSize(width: collectionViewWidth - 28, height: 196)
        }

    }

}
