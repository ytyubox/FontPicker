//
/*
 *		Created by 游宗諭 in 2020/12/21
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import UIKit

protocol ReusableID {
    static var id: String {get}
}

extension UITableView {
    typealias ReusableCell = UITableViewCell & ReusableID
    func dequeueReusableCell<Cell: ReusableCell>(with celltype: Cell.Type) -> Cell {
        dequeueReusableCell(withIdentifier: Cell.id) as! Cell
    }
    func dequeueReusableCell<Cell: ReusableCell>(with celltype: Cell.Type, for indexPath: IndexPath) -> Cell {
        dequeueReusableCell(withIdentifier: Cell.id, for: indexPath) as! Cell
    }
    func register<Cell:ReusableCell>(_ cellType: Cell.Type) {
        register(Cell.self, forCellReuseIdentifier: Cell.id)
    }
}
