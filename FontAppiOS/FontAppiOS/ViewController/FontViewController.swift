//
/*
 *		Created by 游宗諭 in 2021/3/13
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import FontPicker
import UIKit

public protocol FontViewControllerDelegate {
    func didRequestRefresh()
}

public final class FontViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var tableModel: [FontFileCellController] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    fileprivate var loadingControllers = [IndexPath: FontFileCellController]()
    public typealias Delegate = FontViewControllerDelegate
    public var delegate: Delegate?
    @IBOutlet public private(set) var errorView: ErrorView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeTableHeaderToFit()
    }

    @IBAction private func refresh() {
        delegate?.didRequestRefresh()
    }

    override public func numberOfSections(in _: UITableView) -> Int {
        1
    }

    override public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tableModel.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view(tableView: tableView)
    }

    override public func tableView(_: UITableView, didEndDisplaying _: UITableViewCell, forRowAt indexPath: IndexPath) {
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

    private func cellController(forRowAt indexPath: IndexPath) -> FontFileCellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }

    private func cancelCellController(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
}

public extension FontViewController {
    func display(_ cellControllers: [FontFileCellController]) {
        loadingControllers.removeAll(keepingCapacity: true)
        tableModel = cellControllers
    }
}

extension FontViewController: FontLoadingView {
    public func display(_ viewModel: FontLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}

extension FontViewController: FontErrorView {
    public func display(_ viewModel: FontErrorViewModel) {
        errorView.message = viewModel.message
    }
}
