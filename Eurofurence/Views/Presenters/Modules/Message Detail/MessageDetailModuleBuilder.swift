//
//  MessageDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class MessageDetailModuleBuilder {

    private struct DummyMessageDetailModuleProviding: MessageDetailModuleProviding {
        func makeMessageDetailModule(message: Message) {

        }
    }

    func build() -> MessageDetailModuleProviding {
        return DummyMessageDetailModuleProviding()
    }

}
