//
/* 
 *		Created by 游宗諭 in 2021/3/15
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation
func fontToData(font: UIFont) -> Data {
    "\(font)".data(using: .utf8)!
}

