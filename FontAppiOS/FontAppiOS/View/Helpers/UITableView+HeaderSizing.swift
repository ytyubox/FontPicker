//
/*
 *		Created by 游宗諭 in 2021/1/27
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import UIKit

extension UITableView {
    func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }

        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        let needsFrameUpdate = header.frame.height != size.height
        if needsFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
