//
/* 
 *		Created by 游宗諭 in 2021/3/14
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import FontPicker
import UIKit

public final class FontGroupController {
    convenience init(name: String, tableModel: [FontCellController]) {
        self.init()
        self.name = name
        self.tableModel = tableModel
    }
    var name: String = ""
    
    var tableModel = [FontCellController]()
    
    private var cellControllers = [IndexPath:FontCellController]()
//
    func view(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cellController = cellControllers[indexPath]!
        
        let cell = cellController.view(tableView: tableView)
        
//        cellController.delegate.requestLoad()
        return cell
    }
//
//    func preload() {
//        delegate.requestLoad()
//    }
//
//    func cancelLoad() {
//        delegate.cancelLoad()
//        releaseCellForReuse()
//    }
//
//    private func releaseCellForReuse() {
//        cell = nil
//    }
}
