//
//  MessageDetailPresenterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
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

    private(set) var numberOfMessageComponentsAdded = 0
    private(set) var capturedMessageBinder: MessageComponentBinder?
    func addMessageComponent(with binder: MessageComponentBinder) {
        numberOfMessageComponentsAdded += 1
        capturedMessageBinder = binder
    }

}

class CapturingMessageComponent: MessageComponent {

    private(set) var capturedMessageSubject: String?
    func setMessageSubject(_ subject: String) {
        capturedMessageSubject = subject
    }

    private(set) var capturedMessageContents: String?
    func setMessageContents(_ contents: String) {
        capturedMessageContents = contents
    }

}

class MessageDetailPresenterTests: XCTestCase {

    var messageDetailSceneFactory: StubMessageDetailSceneFactory!
    var message: Message!
    var viewController: UIViewController!
    var messagesService: CapturingPrivateMessagesService!

    override func setUp() {
        super.setUp()

        message = AppDataBuilder.makeMessage(authorName: "Author", subject: "Subject", contents: "Contents")
        messageDetailSceneFactory = StubMessageDetailSceneFactory()
        messagesService = CapturingPrivateMessagesService()
        viewController = MessageDetailModuleBuilder()
            .with(messageDetailSceneFactory)
            .with(messagesService)
            .build()
            .makeMessageDetailModule(message: message)
    }

    private func simulateSceneDidLoad() {
        messageDetailSceneFactory.scene.delegate?.messageDetailSceneDidLoad()
    }

    func testReturnTheSceneWhenBuildingTheModule() {
        XCTAssertEqual(viewController, messageDetailSceneFactory.scene)
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

    func testBindTheSubjectOntoTheMessageComponent() {
        simulateSceneDidLoad()
        let component = CapturingMessageComponent()
        messageDetailSceneFactory.scene.capturedMessageBinder?.bind(component)

        XCTAssertEqual(message.subject, component.capturedMessageSubject)
    }

    func testBindTheContentsOfTheMessageOntoTheMessageComponent() {
        simulateSceneDidLoad()
        let component = CapturingMessageComponent()
        messageDetailSceneFactory.scene.capturedMessageBinder?.bind(component)

        XCTAssertEqual(message.contents, component.capturedMessageContents)
    }

    func testTellTheMessagesServiceToMarkTheMessageAsRead() {
        XCTAssertEqual(message, messagesService.messageMarkedAsRead)
    }

}
