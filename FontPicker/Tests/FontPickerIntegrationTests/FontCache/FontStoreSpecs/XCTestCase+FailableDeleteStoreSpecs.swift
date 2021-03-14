

import FontPicker
import LoadingSystem
import XCTest

extension FailableDeleteStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError<SUT: Store>(on sut: SUT, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)

        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }

    func assertThatDeleteHasNoSideEffectsOnDeletionError<SUT: Store>(on sut: SUT, file: StaticString = #filePath, line: UInt = #line) where SUT.Local == LocalFont {
        deleteCache(from: sut)

        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
