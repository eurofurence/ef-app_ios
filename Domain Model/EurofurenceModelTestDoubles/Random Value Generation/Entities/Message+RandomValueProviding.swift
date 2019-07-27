import EurofurenceModel
import TestUtilities

extension MessageCharacteristics: RandomValueProviding {

    public static var random: MessageCharacteristics {
        return MessageCharacteristics(identifier: .random,
                                      authorName: .random,
                                      receivedDateTime: .random,
                                      subject: .random,
                                      contents: .random,
                                      isRead: .random)
    }

}
