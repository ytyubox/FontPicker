//
/*
 *		Created by 游宗諭 in 2021/3/13
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import FontPicker
import Foundation
import TestUtils

private func _uniqueFont(id: Int) -> Font {
    return
        Font(
            name: "font \(id)",
            variants: [
                Variant(name: "vaiant \(id)", fileURL: anyURL()),
            ],
            subsets: ["subset \(id)"],
            category: "category \(id)"
        )
}

func uniqueFonts() -> (models: [Font], local: [LocalFont]) {
    let models = [_uniqueFont(id: 1), _uniqueFont(id: 2)]
    return (models, models.toLocals())
}
