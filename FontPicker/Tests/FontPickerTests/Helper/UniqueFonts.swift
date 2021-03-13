//
/* 
 *		Created by 游宗諭 in 2021/3/13
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation
import TestUtils
import FontPicker
func uniqueFont() -> Font {
    return Font(name: UUID().uuidString, variants: [
        Variant(name: UUID().uuidString, fileURL: anyURL())
    ], subsets: [UUID().uuidString], category: UUID().uuidString)
}

func uniqueFonts() -> (models: [Font], local: [LocalFont]) {
   let models = [uniqueFont(), uniqueFont()]
    return (models, models.toLocals())
}
