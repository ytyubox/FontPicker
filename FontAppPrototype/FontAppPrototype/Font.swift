//
/* 
 *		Created by 游宗諭 in 2021/3/14
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import UIKit
let KDEMO_SIZE:CGFloat = 16
extension FontGroupViewModel {
    
    static var prototype: [FontGroupViewModel] {
        UIFont
            .familyNames
            .map {
                (name) -> FontGroupViewModel in
                let fontNames = UIFont.fontNames(forFamilyName: name)
                let fonts = fontNames.map{ fontname in
                    FontViewModel(name: fontname, font: UIFont(name: fontname, size: KDEMO_SIZE))
                }
                return  FontGroupViewModel(
                    fontName: name,
                    fonts: fonts
                )
            }
    }
}
