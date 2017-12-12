//
//  MessageDetailPresenterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest
import UIKit.UIViewController

struct StubMessageDetailSceneFactory: MessageDetailSceneFactory {
    
    let scene = CapturingMessageDetailScene()
    func makeMessageDetailScene() -> UIViewController & MessageDetailScene {
        return scene
    }
    
}

class CapturingMessageDetailScene: UIViewController, MessageDetailScene {
    
    private(set) var capturedMessageDetailTitle: String?
    func setMessageDetailTitle(_ title: String) {
        capturedMessageDetailTitle = title
    }
    
    private(set) var capturedMessageSubject: String?
    func setMessageSubject(_ subject: String) {
        capturedMessageSubject = subject
    }
    
}

class MessageDetailPresenterTests: XCTestCase {
    
    func testTheAuthorIsSetAsTheTitle() {
        let expected = "Author"
        let message = AppDataBuilder.makeMessage(authorName: expected)
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        _ = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: message)
        
        XCTAssertEqual(expected, messageDetailSceneFactory.scene.capturedMessageDetailTitle)
    }
    
    func testSetTheSubjectOntoTheScene() {
        let expected = "Subject"
        let message = AppDataBuilder.makeMessage(subject: expected)
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        _ = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: message)
        
        XCTAssertEqual(expected, messageDetailSceneFactory.scene.capturedMessageSubject)
    }
    
}
