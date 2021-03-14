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
    public convenience init(name: String, tableModel: [FontCellController]) {
        self.init()
//        self.demoText = demoText
        self.name = name
        self.tableModel = tableModel
    }

    private var name: String = ""
//    private var demoText: String = ""
    private var tableModel = [FontCellController]()

    private var loadingControllers = [IndexPath: FontCellController]()

    func view(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cellController = tableModel[indexPath.row]
        let cell = cellController.view(tableView: tableView)
        return cell
    }

    private func cellController(forRowAt indexPath: IndexPath) -> FontCellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }

    private func cancelCellController(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }

    deinit {
        loadingControllers.removeAll()
    }
}

extension FontGroupController: TableViewSource {
    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        name
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tableModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view(tableView: tableView)
    }
}

extension FontGroupController: TableViewDisplay {
    public func tableView(_: UITableView, didEndDisplaying _: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellController(forRowAt: indexPath)
    }

    public func tableView(_: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }

    public func tableView(_: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellController(forRowAt:))
    }
}
