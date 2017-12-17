//
//  MessageComponentBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol MessageComponentBinder {

    func bind(_ component: MessageComponent, toMessageAt index: Int)

}
