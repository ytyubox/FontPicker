//
/*
 *		Created by 游宗諭 in 2020/12/25
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing
            ? beginRefreshing()
            : endRefreshing()
    }
}
