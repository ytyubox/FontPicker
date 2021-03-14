//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPicker
import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func uniqueFont(variants: [Variant] = [
    Variant(name: UUID().uuidString, fileURL: anyURL()),
]) -> Font {
    return Font(name: UUID().uuidString,
                variants: variants,
                subsets: [UUID().uuidString],
                category: UUID().uuidString)
}

func uniqueFonts() -> (models: [Font], local: [LocalFont]) {
    let models = [uniqueFont(), uniqueFont()]
    return (models, models.toLocals())
}
