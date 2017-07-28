//
//  UnreadMessageIndicator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

@IBDesignable
class UnreadMessageIndicator: UIView {

    override var frame: CGRect {
        didSet {
            layer.cornerRadius = frame.height / 2
        }
    }

}
