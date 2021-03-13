//
/*
 *		Created by 游宗諭 in 2021/3/13
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import CoreData

@objc(ManagedVariant)
class ManagedVariant: NSManagedObject {
    @NSManaged var url: URL
    @NSManaged var name: String
    @NSManaged var data: Data?
    @NSManaged var font: ManagedFont
}

extension ManagedVariant {
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedVariant? {
        let request = NSFetchRequest<ManagedVariant>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedVariant.url), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    static func variants(from localVariants: [LocalFont.LocalVariant], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localVariants.map { local in
            let managed = ManagedVariant(context: context)
            managed.name = local.name
            managed.data = local.data
            managed.url = local.fileURL
            return managed
        })
    }

    var local: LocalFont.LocalVariant {
        return LocalFont.LocalVariant(name: name, fileURL: url, data: data)
    }
}
