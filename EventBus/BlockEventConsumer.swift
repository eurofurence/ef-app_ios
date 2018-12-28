//
//  BlockEventConsumer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

public class BlockEventConsumer<T>: EventConsumer {

    private let block: (T) -> Void

    public init(block: @escaping (T) -> Void) {
        self.block = block
    }

    public typealias Event = T

    public func consume(event: BlockEventConsumer.Event) {
        block(event)
    }

}
