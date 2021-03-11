//
/* 
 *		Created by 游宗諭 in 2021/3/11
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import XCTest
@testable import FontPickerApp

class FontPickerAppTests: XCTestCase {
    
    
    
    override func setUpWithError() throws {
        try guardMainbundleHaveAPIKEYElseSkip()
    }
    func test() {
        XCTFail()
    }
    
    fileprivate func guardMainbundleHaveAPIKEYElseSkip(file: StaticString = #file, line: UInt = #line) throws {
        let bundle = Bundle.main
        let dictory = try XCTUnwrap(bundle.infoDictionary)
        let valueFromKey = dictory[APIKEY_PLISTKEY]
        let value = try XCTUnwrap(valueFromKey)
        let key = try XCTUnwrap(value as? String)
        if key.isEmpty {
            throw XCTSkip("API key is empty, set the key in secrets.xccongfig file",file: file, line: line)
        }
    }
}

private let APIKEY_PLISTKEY = "GOOGLEAPIKEY"
