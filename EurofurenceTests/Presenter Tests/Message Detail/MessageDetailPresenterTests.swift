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
    
    func testTheAuthorIsSetAsTheTitle() {
        let expected = "Author"
        let message = AppDataBuilder.makeMessage(authorName: expected)
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        _ = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: message)
        messageDetailSceneFactory.scene.delegate?.messageDetailSceneWillAppear()
        
        XCTAssertEqual(expected, messageDetailSceneFactory.scene.capturedMessageDetailTitle)
    }
    
    func testTellTheSceneToAddMessageComponents() {
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        _ = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: AppDataBuilder.makeMessage())
        messageDetailSceneFactory.scene.delegate?.messageDetailSceneDidLoad()
        
        XCTAssertEqual(1, messageDetailSceneFactory.scene.numberOfMessageComponentsAdded)
    }
    
    func testWaitsUntilTheSceneLoadsBeforeAddingMessageComponent() {
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        _ = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: AppDataBuilder.makeMessage())
        
        XCTAssertEqual(0, messageDetailSceneFactory.scene.numberOfMessageComponentsAdded)
    }
    
    func testSetTheSubjectOntoTheScene() {
        let expected = "Subject"
        let message = AppDataBuilder.makeMessage(subject: expected)
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        _ = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: message)
        messageDetailSceneFactory.scene.delegate?.messageDetailSceneWillAppear()
        
        XCTAssertEqual(expected, messageDetailSceneFactory.scene.capturedMessageSubject)
    }
    
    func testSetTheContentsOfTheMessageOntoTheScene() {
        let expected = "Message"
        let message = AppDataBuilder.makeMessage(contents: expected)
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        _ = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: message)
        messageDetailSceneFactory.scene.delegate?.messageDetailSceneWillAppear()
        
        XCTAssertEqual(expected, messageDetailSceneFactory.scene.capturedMessageContents)
    }
    
    func testReturnTheSceneWhenBuildingTheModule() {
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        let vc = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: AppDataBuilder.makeMessage())
        
        XCTAssertEqual(messageDetailSceneFactory.scene, vc)
    }
    
    func testWaitForTheSceneToNotifyItWillAppearBeforeSettingTitle() {
        let unexpected = "Author"
        let message = AppDataBuilder.makeMessage(authorName: unexpected)
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        _ = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: message)
        
        XCTAssertNotEqual(unexpected, messageDetailSceneFactory.scene.capturedMessageDetailTitle)
    }
    
    func testWaitForSceneToNotifyItWillAppearBeforeSettingSubject() {
        let unexpected = "Subject"
        let message = AppDataBuilder.makeMessage(subject: unexpected)
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        _ = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: message)
        
        XCTAssertNotEqual(unexpected, messageDetailSceneFactory.scene.capturedMessageSubject)
    }
    
    func testWaitForSceneToNotifyItWillAppearBeforeSettingContents() {
        let unexpected = "Message"
        let message = AppDataBuilder.makeMessage(contents: unexpected)
        let messageDetailSceneFactory = StubMessageDetailSceneFactory()
        _ = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .build()
            .makeMessageDetailModule(message: message)
        
        XCTAssertNotEqual(unexpected, messageDetailSceneFactory.scene.capturedMessageContents)
    }
    
}
