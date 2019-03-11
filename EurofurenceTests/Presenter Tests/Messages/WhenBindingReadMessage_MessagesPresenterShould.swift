//
//  WhenBindingReadMessage_MessagesPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenBindingReadMessage_MessagesPresenterShould: XCTestCase {

    func testTheSceneIsToldToHideUnreadIndicatorForReadMessage() {
        var allMessages = [StubMessage].random
        let randomIndex = Int.random(upperLimit: UInt32(allMessages.count))
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        var randomMessage = allMessages[randomIndex]
        randomMessage.isRead = true
        allMessages[randomIndex] = randomMessage
        
        let service = CapturingPrivateMessagesService(localMessages: allMessages)
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh(messages: allMessages)
        let capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
        
        XCTAssertEqual(capturingMessageScene.unreadIndicatorVisibility, .hidden)
    }

}
