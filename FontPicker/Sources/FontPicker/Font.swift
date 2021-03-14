import Foundation
public struct Font:Hashable {
    
    public init(name: String, variants: [Variant], subsets: [String], category: String) {
        self.name = name
        self.variants = variants
        self.subsets = subsets
        self.category = category
    }
    
    public let name:String
    public let variants: [Variant]
    public let subsets:[String]
    public let category:String

}

public struct Variant:Hashable {
    public init(name: String,
                fileURL: URL,
                data: Data? = nil) {
        self.name = name
        self.fileURL = fileURL
        self.data = data
    }
    
   
    
    public let name: String
    public let fileURL: URL
    public let data:Data?
}
