//
/*
 *		Created by 游宗諭 in 2021/3/13
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import Foundation
import LoadingSystem
final class FontItemsMapper {
    struct Root: Codable {
        let kind: String
        let items: [RemoteFont]
    }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFont] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteError.invalidData
        }

        return root.items
    }
}
