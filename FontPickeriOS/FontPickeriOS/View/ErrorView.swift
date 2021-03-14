//
/*
 *		Created by 游宗諭 in 2020/12/24
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import UIKit

public final class ErrorView: UIView {
    @IBOutlet private var label: UILabel! {
        didSet {
            label.text = ""
        }
    }

    public var message: String? {
        set { setMessageAnimated(newValue) }
        get { isVisible ? label.text : nil }
    }

    private var isVisible: Bool {
        alpha > 0
    }

    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }

    private func showAnimated(_ message: String) {
        label.text = message

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @IBAction private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.label.text = nil }
            }
        )
    }
}
