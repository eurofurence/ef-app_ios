//
//  MessagesScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol MessagesSceneDelegate {

    func messagesSceneDidSelectMessage(at indexPath: IndexPath)

}

protocol MessagesScene: class {

    var delegate: MessagesSceneDelegate? { get set }

    func showRefreshIndicator()
    func hideRefreshIndicator()

    func showMessages(_ viewModel: MessagesViewModel)

}

struct MessagesViewModel: Equatable {

    // MARK: Properties

    private var viewModels: [MessageViewModel]

    var numberOfMessages: Int {
        return viewModels.count
    }

    // MARK: Initialization

    init(messages: [Message]) {
        self.viewModels = messages.map(MessageViewModel.init)
    }

    init(childViewModels: [MessageViewModel]) {
        viewModels = childViewModels
    }

    // MARK: Functions

    func messageViewModel(at index: Int) -> MessageViewModel {
        return viewModels[index]
    }

    // MARK: Equatable

    static func ==(lhs: MessagesViewModel, rhs: MessagesViewModel) -> Bool {
        return lhs.viewModels == rhs.viewModels
    }

}

struct MessageViewModel: Equatable {

    // MARK: Properties

    var title: String

    // MARK: Initialization

    init(message: Message) {
        self.title = message.authorName
    }

    init(title: String) {
        self.title = title
    }

    // MARK: Equatable

    static func ==(lhs: MessageViewModel, rhs: MessageViewModel) -> Bool {
        return lhs.title == rhs.title
    }

}
