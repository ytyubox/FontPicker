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

struct FontGroupViewModel {
    let fontName: String
    let fonts: [FontViewModel]
}

struct FontViewModel {
    let name: String
    let font: UIFont?
}

public protocol FontViewControllerDelegate {
    func didRequestRefresh()
}

let introducing =
    """
    A Font Picker for Google Font API
    Support:
        1. Off line Picker
        2. Dynamic font
        3. Dark mode
    """

public final class FontViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private lazy var firstSection: IntroduceSectionController! = IntroduceSectionController(content: introducing)
    private var tableModel: [FontGroupController] = [] {
        didSet {
            sectionController = makeSectionControllers()
            tableView.reloadData()
        }
    }

    private var sectionController: [TableViewSource] = []
     

    private func makeSectionControllers() -> [TableViewSource] {
        [
            [firstSection as TableViewSource],
            tableModel.map { $0 as TableViewSource },
        ].flatMap { $0 }
    }
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
        sectionController.count
    }

    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionController[section].tableView(tableView, titleForHeaderInSection: section)
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionController[section].tableView(tableView, numberOfRowsInSection: section)
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sectionController[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
    }

    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (sectionController[indexPath.section] as? TableViewDisplay)?
            .tableView(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            (sectionController[indexPath.section] as? TableViewDisplay)?
                .tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            (sectionController[indexPath.section] as? TableViewDisplay)?
                .tableView(tableView, cancelPrefetchingForRowsAt: [indexPath])
        }
    }

    private func SectionController(forRowAt indexPath: IndexPath) -> FontGroupController {
        tableModel[indexPath.section]
    }
}

public extension FontViewController {
    func display(_ fontGroupControllers: [FontGroupController]) {
        tableModel = fontGroupControllers
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
