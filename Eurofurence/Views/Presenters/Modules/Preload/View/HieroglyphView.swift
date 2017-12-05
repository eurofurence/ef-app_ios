//
//  HieroglyphView.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIView

@IBDesignable
class HieroglyphView: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()

        font = UIFont(name: "Hieroglyphy", size: 196.0)
        textAlignment = .center
        textColor = .white
        updateHieroglyph()
    }

    private func updateHieroglyph() {
        text = String(makeRandomHieroglyphCharacter())
    }

    private func makeRandomHieroglyphCharacter() -> Character {
        let availableChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        let length = availableChars.count
        let index = Int(arc4random_uniform(UInt32(length)))
        let stringIndex = availableChars.index(availableChars.startIndex, offsetBy: index)

        return availableChars[stringIndex]
    }

}
