//
/*
 *		Created by 游宗諭 in 2020/12/21
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import UIKit

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(with _: Cell.Type) -> Cell {
        dequeueReusableCell(withIdentifier: "\(Cell.self)") as! Cell
    }
}
