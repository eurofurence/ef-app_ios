import XCTest

func XCTAssertEventuallyNoThrow(
    _ expression: () async throws -> Void,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        try await expression()
    } catch {
        XCTFail(message(), file: file, line: line)
    }
}
