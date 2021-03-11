//
/* 
 *		Created by 游宗諭 in 2021/3/11
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation

// MARK: - Font
struct Root: Codable {
    let kind: String
    let items: [RemoteFont]
}

// MARK: - Item
struct RemoteFont: Codable {
    let family: String
    let variants: [String]
    let subsets: [String]
    let version: String
    let lastModified: String
    let files: [String: URL]
    let category: String
    let kind: String
}

