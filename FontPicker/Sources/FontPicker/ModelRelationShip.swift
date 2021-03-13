//
/* 
 *		Created by 游宗諭 in 2021/3/13
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import LoadingSystem

extension Font: AModel {
    public var local: Never {
        fatalError("Yet")
    }
    
    public typealias Local = Never
    
    
}
extension RemoteFont: RemoteModel {
    public var model: Font {
        var variantsModel = [Variant]()
        for name in variants {
            guard let fileURL = files[name] else {continue}
            variantsModel.append(Variant(name: name, fileURL: fileURL))
        }
        return Font(name: family, variants: variantsModel, subsets: subsets, category: category)
    }
    
    public typealias Model = Font
    
    
}
