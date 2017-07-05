//
//  MenuTableViewCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

open class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var textIconImage: UIImageView!
    @IBOutlet weak var menuTextLabel: UILabel!

    var menuIcon = [String: UIImage]()
	class var identifier: String { return String(describing: self) }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    open func setup() {
        self.menuIcon.updateValue(UIImage(named: "Settings")!, forKey: "Settings")
        self.menuIcon.updateValue(UIImage(named: "AboutUs")!, forKey: "About")
    }

    open class func height() -> CGFloat {
        return 48
    }

    open func setData(_ data: Any?) {
        self.backgroundColor = UIColor.white
        if let menuText = data as? String {
            if let image = menuIcon[menuText] {
                self.textIconImage?.image = image
                self.menuTextLabel?.text = menuText
            } else {
                self.menuTextLabel?.text = menuText
            }
        }
    }

    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }

    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }

}
