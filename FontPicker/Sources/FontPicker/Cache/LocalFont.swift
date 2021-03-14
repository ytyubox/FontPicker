//
/* 
 *		Created by 游宗諭 in 2021/3/13
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation

import Foundation
public struct LocalFont:Equatable {
    public init(name: String, variants: [LocalFont.LocalVariant], subsets: [String], category: String) {
        self.name = name
        self.variants = variants
        self.subsets = subsets
        self.category = category
    }
    
    public let name:String
    public let variants: [LocalVariant]
    public let subsets:[String]
    public let category:String
    public struct LocalVariant:Equatable {
        public init(name: String,
                    fileURL: URL,
                    data: Data?) {
            self.name = name
            self.fileURL = fileURL
            self.data = data
        }
        
        public let name: String
        public let fileURL: URL
        public let data:Data?
    }
}
