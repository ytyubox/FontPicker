//
/* 
 *		Created by 游宗諭 in 2021/3/15
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation
import UIKit
 class UIFontMaker {
    @Lock private var fontBook: [URL: UIFont] = [:]
    enum CreateFromDataFailure: Error {
        case
            noCGDataProvider,
            noCGFont,
            noCTFontManagerRegisterGraphicsFont,
            noFontName,
            noUIFontWithName
    
    }
    func build(url:URL, data: Data) throws -> UIFont{
        try build(url: url, data: data, size: 30)
    }
    func build(url:URL, data: Data, size: CGFloat) throws -> UIFont{
        if let font = fontBook[url] {return font}
        guard
            let dataProvider = CGDataProvider(data: data as CFData)
        else {
            throw CreateFromDataFailure.noCGDataProvider
        }
        guard let cgFont = CGFont(dataProvider)
        else {
            throw CreateFromDataFailure.noCGFont
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
            throw CreateFromDataFailure.noCTFontManagerRegisterGraphicsFont
        } else {
            guard let fontName = cgFont.postScriptName else {
                throw CreateFromDataFailure.noFontName
            }
            
            guard let object = UIFont(name: String(fontName), size: size) else {
                throw CreateFromDataFailure.noUIFontWithName
            }
            fontBook[url] = object
            return object
        }
    }
}
