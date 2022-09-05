import XCTest

public func XCTAssertThrowsSpecificError<E>(
    _ expected: E,
    _ block: () throws -> Void,
    file: StaticString = #file,
    line: UInt = #line
) where E: Error & Equatable {
    do {
        try block()
        XCTFail("Expected to throw an error.", file: file, line: line)
    } catch let error as E {
        XCTAssertEqual(expected, error, file: file, line: line)
    } catch {
        XCTFail("Unexpected error thrown: \(error)", file: file, line: line)
    }
}

public func XCTAssertEventuallyThrowsSpecificError<E>(
    _ expected: E,
    _ block: () async throws -> Void,
    file: StaticString = #file,
    line: UInt = #line
) async where E: Error & Equatable {
    do {
        try await block()
        XCTFail("Expected to throw an error.", file: file, line: line)
    } catch let error as E {
        XCTAssertEqual(expected, error, file: file, line: line)
    } catch {
        XCTFail("Unexpected error thrown: \(error)", file: file, line: line)
    }
}

public func XCTAssertEventuallyThrowsError(
    _ block: () async throws -> Void,
    file: StaticString = #file,
    line: UInt = #line
) async {
    do {
        try await block()
        XCTFail("Expected to throw an error.", file: file, line: line)
    } catch {
        // 👍
    }
}

public func XCTAssertEventuallyNoThrows(
    _ block: () async throws -> Void,
    file: StaticString = #file,
    line: UInt = #line
) async {
    do {
        try await block()
        // 👍
    } catch {
        XCTFail("Unexpected error raised: \(error)", file: file, line: line)
    }
}
