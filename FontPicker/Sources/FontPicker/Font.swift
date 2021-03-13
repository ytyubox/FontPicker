import Foundation
public struct Font {
    public let name:String
    public let variants: [Variant]
    public let subsets:String
    public let category:String

}

public struct Variant {
    public let name: String
    public let fileURL: URL
}
