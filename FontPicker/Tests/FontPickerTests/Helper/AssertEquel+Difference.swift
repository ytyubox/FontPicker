//
/* 
 *		Created by 游宗諭 in 2021/3/13
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import XCTest
import Difference
func XCTAssertEqual<T: Equatable>(_ received : @autoclosure () throws -> T, _ expected: @autoclosure () throws -> T, file: StaticString = #filePath, line: UInt = #line) {
    do {
        let expected = try expected()
        let received = try received()
        XCTAssertTrue(expected == received, "Found difference for \n" + diff(expected, received).joined(separator: ", "), file: file, line: line)
    }
    catch {
        XCTFail("Caught error while testing: \(error)", file: file, line: line)
    }
}
