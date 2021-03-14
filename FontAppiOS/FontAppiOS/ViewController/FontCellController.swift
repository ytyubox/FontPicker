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

public protocol FontCellControllerDelegate {
    func requestLoad()
    func cancelLoad()
}

public final class FontCellController {
    private let delegate: FontCellControllerDelegate

    private var cell: FontCell?
    public init(delegate: FontCellControllerDelegate) {
        self.delegate = delegate
    }

    func view(tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(with: FontCell.self)
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

extension FontCellController: FontFileView {
    public typealias Union = FontFileViewModel<FONT>.VariantViewModel
    
    public typealias FONT = UIFont
    
    public func display(_ viewModel: Union) {
        cell?.retryButton.isHidden = viewModel.shouldRetry
        cell?.nameLabel.text = viewModel.weight
        cell?.fontLabel.font = viewModel.font
        cell?.fontLabel.isHidden = !viewModel.shouldRetry
    }

}
