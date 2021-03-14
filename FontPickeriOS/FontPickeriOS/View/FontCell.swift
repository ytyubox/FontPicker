/**
 * Created by 游宗諭 in 2020/12/14
 *
 *
 * Using Swift 5.0
 *
 * Running on macOS 10.15
 */

import UIKit

public final class FontCell: UITableViewCell, ReusableID {
    static var id: String { "FontCell" }
    @IBOutlet public private(set) var fontLabel: UILabel!
    @IBOutlet public private(set) var nameLabel: UILabel!
    @IBOutlet public private(set) var retryButton: UIButton!
    @IBOutlet public private(set) var fontContainer: ShimmeringView!

    var onRetry: (() -> Void)?
    @IBAction private func retryButtonTapped() {
        onRetry?()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        [
            nameLabel,
            fontLabel,
        ].forEach {
            label in
            label.adjustsFontForContentSizeCategory = true
        }
        accessibilityIdentifier = "font-cell"
        fontLabel.accessibilityIdentifier = "font-view"
    }
}
