//
/*
 *		Created by 游宗諭 in 2020/12/21
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage

        guard newImage != nil else { return }

        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
