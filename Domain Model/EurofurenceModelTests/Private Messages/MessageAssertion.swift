import EurofurenceModel
import TestUtilities

class MessageAssertion: Assertion {

    func assertMessages(_ messages: [Message], characterisedBy characteristics: [MessageCharacteristics]) {
        guard messages.count == characteristics.count else {
            fail(message: "Differing amount of expected/actual messages")
            return
        }

        let sortedCharacteristics = characteristics.sorted { (first, second) -> Bool in
            return first.receivedDateTime.compare(second.receivedDateTime) == .orderedDescending
        }

        for (idx, message) in messages.enumerated() {
            let characteristic = sortedCharacteristics[idx]
            assertMessage(message, characterisedBy: characteristic)
        }
    }

    func assertMessage(_ message: Message?, characterisedBy characteristic: MessageCharacteristics) {
        guard let message = message else {
            fail(message: "Expected a message with id \(characteristic.identifier), got nil")
            return
        }
        
        let observer = CapturingPrivateMessageObserver()
        message.add(observer)
        
        let expectedReadState: CapturingPrivateMessageObserver.ReadState = characteristic.isRead ? .read : .unread
        
        assert(message.identifier.rawValue, isEqualTo: characteristic.identifier)
        assert(message.authorName, isEqualTo: characteristic.authorName)
        assert(message.receivedDateTime, isEqualTo: characteristic.receivedDateTime)
        assert(message.subject, isEqualTo: characteristic.subject)
        assert(message.contents, isEqualTo: characteristic.contents)
        assert(expectedReadState, isEqualTo: observer.currentReadState)
    }

}
