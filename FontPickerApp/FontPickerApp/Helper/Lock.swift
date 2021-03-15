//
/* 
 *		Created by 游宗諭 in 2021/3/15
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation

@propertyWrapper final class Lock<Value>  {
    
    private let lock = NSLock()
    private var value :Value
    
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    var wrappedValue: Value {
        get{ return value }
        _modify {
            lock.lock()
            defer { lock.unlock() }
            yield &value
        }
    }
}
