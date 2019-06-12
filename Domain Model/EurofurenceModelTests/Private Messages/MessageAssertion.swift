import EurofurenceModel
import TestUtilities

class MessageAssertion: Assertion {

    func assertMessages(_ messages: [Message], characterisedBy characteristics: [MessageCharacteristics]) {
        guard messages.count == characteristics.count else {
            fail(message: "Differing amount of expected/actual messages")
            return
        }

        var sortedCharacteristics = characteristics.sorted { (first, second) -> Bool in
            return first.receivedDateTime.compare(second.receivedDateTime) == .orderedDescending
        }

        for (idx, message) in messages.enumerated() {
            let characteristic = sortedCharacteristics[idx]
            assertMessage(message, characterisedBy: characteristic)
        }
    }

    func assertMessage(_ message: Message, characterisedBy characteristic: MessageCharacteristics) {
        assert(message.identifier, isEqualTo: characteristic.identifier)
        assert(message.authorName, isEqualTo: characteristic.authorName)
        assert(message.receivedDateTime, isEqualTo: characteristic.receivedDateTime)
        assert(message.subject, isEqualTo: characteristic.subject)
        assert(message.contents, isEqualTo: characteristic.contents)
        assert(message.isRead, isEqualTo: characteristic.isRead)
    }

}
