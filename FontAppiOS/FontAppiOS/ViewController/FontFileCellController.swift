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

public protocol FontFileCellControllerDelegate {
    func requestLoad()
    func cancelLoad()
}

public final class FontFileCellController {
    private let delegate: FontFileCellControllerDelegate

    private var cell: FontFileCell?
    public init(delegate: FontFileCellControllerDelegate) {
        self.delegate = delegate
    }

    func view(tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(with: FontFileCell.self)
        delegate.requestLoad()
        return cell!
    }

    func preload() {
        delegate.requestLoad()
    }

    func cancelLoad() {
        delegate.cancelLoad()
        releaseCellForReuse()
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}

extension FontFileCellController: FontFileView {
    public func display(_: FontFileViewModel<F>) {}

    public typealias F = UIFont
    public typealias Union = FontFileViewModel<F>
}
