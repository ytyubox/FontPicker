//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPicker
import LoadingSystem
import TestUtils
import XCTest

extension FailableRetrieveStoreSpecs where Self: XCTestCase {
    typealias Local = LocalFont
    func assertThatRetrieveDeliversFailureOnRetrievalError<SUT: Store>(on sut: SUT, file: StaticString = #filePath, line: UInt = #line) where SUT.Local == Local {
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnFailure<SUT: Store>(on sut: SUT, file: StaticString = #filePath, line: UInt = #line) where SUT.Local == Local {
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }
}
