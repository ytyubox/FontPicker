//
/* 
 *		Created by 游宗諭 in 2021/3/11
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import XCTest
private let APIKEY_PLISTKEY = "GOOGLEAPIKEY"

final class ATests: XCTestCase {
    func testMainBundleHaveAPIKEY() throws {
        let bundle = Bundle.main
        let dictory = try XCTUnwrap(bundle.infoDictionary)
        let valueFromKey = d[APIKEY_PLISTKEY]
        let value = try XCTUnwrap(valueFromKey)
        let key = try XCTUnwrap(value as? String)
        XCTAssertFalse(key.isEmpty)
        
    }
}
