//
/* 
 *		Created by 游宗諭 in 2021/3/14
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import UIKit

class FontCell: UITableViewCell {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [nameLabel, fontLabel].forEach{
            
            $0.adjustsFontForContentSizeCategory = true
        }
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)

        fontLabel.alpha = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        fontLabel.alpha = 0
    }
    
    func fadeIn(_ font: UIFont?) {
        
        fontLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font!)
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.3,
            options: [],
            animations: {
                self.fontLabel.alpha = 1
            })
    }

}
