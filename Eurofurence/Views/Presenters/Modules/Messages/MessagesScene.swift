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

    static func ==(lhs: MessagesViewModel, rhs: MessagesViewModel) -> Bool {
        return true
    }

}
