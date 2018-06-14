//
//  ScheduleDaysView.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class ScheduleDaysView: UIView {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private var daysController: DaysController? {
        didSet {
            collectionView.dataSource = daysController
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        addSubview(collectionView)
        if #available(iOS 11.0, *) {
            collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }

        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        collectionView.register(ScheduleDayCollectionViewCell.self)
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        applyHairlineBorderUnderneathViewToSimulateNavigationBarBase()
    }

    private func applyHairlineBorderUnderneathViewToSimulateNavigationBarBase() {
        layer.shadowOffset = CGSize(width: 0, height: CGFloat(1) / UIScreen.main.scale)
        layer.shadowRadius = 0
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOpacity = 0.25
    }

    func bind(numberOfDays: Int, using binder: ScheduleDaysBinder) {
        daysController = DaysController(numberOfDays: numberOfDays, binder: binder)
    }

    private class DaysController: NSObject, UICollectionViewDataSource {

        private let numberOfDays: Int
        private let binder: ScheduleDaysBinder

        init(numberOfDays: Int, binder: ScheduleDaysBinder) {
            self.numberOfDays = numberOfDays
            self.binder = binder
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return numberOfDays
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeue(ScheduleDayCollectionViewCell.self, for: indexPath)
            binder.bind(cell, forDayAt: indexPath.item)
            return cell
        }

    }

}
