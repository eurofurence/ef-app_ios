//
//  MessagesScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol MessagesScene {

    func showRefreshIndicator()
    func hideRefreshIndicator()

    func showMessages(_ viewModel: MessagesViewModel)

}

struct MessagesViewModel: Equatable {

    // MARK: Properties

    private var messages: [MessageViewModel]

    // MARK: Initialization

    init(messages: [Message] = []) {
        self.messages = messages.map(MessageViewModel.init)
    }

    // MARK: Equatable

    static func ==(lhs: MessagesViewModel, rhs: MessagesViewModel) -> Bool {
        return lhs.messages == rhs.messages
    }

}

struct MessageViewModel: Equatable {

    // MARK: Properties

    private var message: Message

    // MARK: Initialization

    init(message: Message) {
        self.message = message
    }

    // MARK: Equatable

    static func ==(lhs: MessageViewModel, rhs: MessageViewModel) -> Bool {
        return lhs.message == rhs.message
    }

}
