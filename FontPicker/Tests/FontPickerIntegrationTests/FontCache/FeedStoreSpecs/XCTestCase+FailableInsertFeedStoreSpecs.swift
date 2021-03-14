

import FontPicker
import LoadingSystem
import XCTest

extension FailableInsertStoreSpecs where Self: XCTestCase {
    typealias Local = LocalFont
    func assertThatInsertDeliversErrorOnInsertionError<SUT: Store>(on sut: SUT, file: StaticString = #filePath, line: UInt = #line) where SUT.Local == Local {
        let insertionError = insert((uniqueFonts().local, Date()), to: sut)

        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }

    func assertThatInsertHasNoSideEffectsOnInsertionError<SUT: Store>(on sut: SUT, file: StaticString = #filePath, line: UInt = #line) where SUT.Local == Local {
        insert((uniqueFonts().local, Date()), to: sut)

        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
