//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPicker
import Foundation
import XCTest

extension FontUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Font"
        let bundle = Bundle(identifier: "com.essentialdeveloper.FontPicker")!
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
