//
//  TutorialBlockAction.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct TutorialBlockAction: TutorialAction {

    var block: () -> Void

    init(block: @escaping () -> Void) {
        self.block = block
    }

    func run() {
        block()
    }

}
