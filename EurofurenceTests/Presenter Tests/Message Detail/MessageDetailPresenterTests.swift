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
    
    var delegate: MessageDetailSceneDelegate?
    
    private(set) var capturedMessageDetailTitle: String?
    func setMessageDetailTitle(_ title: String) {
        capturedMessageDetailTitle = title
    }
    
    private(set) var capturedMessageSubject: String?
    func setMessageSubject(_ subject: String) {
        capturedMessageSubject = subject
    }
    
    private(set) var capturedMessageContents: String?
    func setMessageContents(_ contents: String) {
        capturedMessageContents = contents
    }
    
    private(set) var numberOfMessageComponentsAdded = 0
    func addMessageComponent() {
        numberOfMessageComponentsAdded += 1
    }
    
}

class MessageDetailPresenterTests: XCTestCase {
    
    var messageDetailSceneFactory: StubMessageDetailSceneFactory!
    var message: Message!
    var viewController: UIViewController!
    
    override func setUp() {
        super.setUp()
        
        message = AppDataBuilder.makeMessage(authorName: "Author", subject: "Subject", contents: "Contents")
        messageDetailSceneFactory = StubMessageDetailSceneFactory()
        viewController = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: message)
    }
    
    private func simulateSceneDidLoad() {
        messageDetailSceneFactory.scene.delegate?.messageDetailSceneDidLoad()
    }
    
    private func simulateSceneWillAppear() {
        messageDetailSceneFactory.scene.delegate?.messageDetailSceneWillAppear()
    }
    
    func testTheAuthorIsSetAsTheTitle() {
        simulateSceneDidLoad()
        XCTAssertEqual(message.authorName, messageDetailSceneFactory.scene.capturedMessageDetailTitle)
    }
    
    func testWaitForTheSceneToLoadBeforeSettingTitle() {
        XCTAssertNotEqual(message.authorName, messageDetailSceneFactory.scene.capturedMessageDetailTitle)
    }
    
    func testTellTheSceneToAddMessageComponents() {
        simulateSceneDidLoad()
        XCTAssertEqual(1, messageDetailSceneFactory.scene.numberOfMessageComponentsAdded)
    }
    
    func testWaitsUntilTheSceneLoadsBeforeAddingMessageComponent() {
        XCTAssertEqual(0, messageDetailSceneFactory.scene.numberOfMessageComponentsAdded)
    }
    
    func testSetTheSubjectOntoTheScene() {
        simulateSceneWillAppear()
        XCTAssertEqual(message.subject, messageDetailSceneFactory.scene.capturedMessageSubject)
    }
    
    func testSetTheContentsOfTheMessageOntoTheScene() {
        simulateSceneWillAppear()
        XCTAssertEqual(message.contents, messageDetailSceneFactory.scene.capturedMessageContents)
    }
    
    func testReturnTheSceneWhenBuildingTheModule() {
        XCTAssertEqual(viewController, messageDetailSceneFactory.scene)
    }
    
    func testWaitForTheSceneToNotifyItWillAppearBeforeSettingTitle() {
        XCTAssertNotEqual(message.authorName, messageDetailSceneFactory.scene.capturedMessageDetailTitle)
    }
    
    func testWaitForSceneToNotifyItWillAppearBeforeSettingSubject() {
        XCTAssertNotEqual(message.subject, messageDetailSceneFactory.scene.capturedMessageSubject)
    }
    
    func testWaitForSceneToNotifyItWillAppearBeforeSettingContents() {
        XCTAssertNotEqual(message.contents, messageDetailSceneFactory.scene.capturedMessageContents)
    }
    
}
