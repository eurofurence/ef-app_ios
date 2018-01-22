//
//  BlockEventConsumer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

class BlockEventConsumer<T>: EventConsumer {

    private let block: (T) -> Void

    init(block: @escaping (T) -> Void) {
        self.block = block
    }

    typealias Event = T

    func consume(event: BlockEventConsumer.Event) {
        block(event)
    }

}
