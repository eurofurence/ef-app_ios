//
//  TutorialPageInfo.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct TutorialPageInfo {

    var image: UIImage?
    var title: String?
    var description: String?

    init(image: UIImage?, title: String?, description: String?) {
        self.image = image
        self.title = title
        self.description = description
    }

}
