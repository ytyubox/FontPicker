//
/* 
 *		Created by 游宗諭 in 2021/3/12
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation
enum FontFileViewModelMapper<F> {
    static func failure(_ model: Font, with error:Error) -> FontFileViewModel<F> {
        FontFileViewModel(
            font: nil
        )
    }
    static func loading(for model: Font) -> FontFileViewModel<F> {
        FontFileViewModel(
            font: nil
        )
    }
    
    static func success(
        with data: Data,
        fontTransformer: (Data) -> F?,
        for model: Font) -> FontFileViewModel<F> {
        let font = fontTransformer(data)
        return FontFileViewModel(
            font: font
        )
    }
}
