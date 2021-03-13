//
/* 
 *		Created by 游宗諭 in 2021/3/13
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */

import LoadingSystem
import Foundation
public final class RemoteFontLoader: RemoteLoader<[Font]> {
    public convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client) { (data, response) -> [Font] in
            try FontItemsMapper.map(data, from: response).toModels()
        }
    }
}

