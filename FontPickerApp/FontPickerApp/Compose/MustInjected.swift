//
/*
 *		Created by 游宗諭 in 2020/12/22
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import Foundation

// MARK: - transfer property injection to lazy injection

@propertyWrapper struct MustInjected<Value> {
    private var _value: Value!

    #if DEBUG
        let line: UInt
        let file: StaticString
    #endif

    @available(*, unavailable, message: "using @MustInjected(#file, #line)")
    init(wrappedValue _: @autoclosure @escaping () -> Value) {
        _value = nil
        line = #line
        file = #file
    }

    init(_ file: StaticString, _ line: UInt) {
        _value = nil
        #if DEBUG
            self.file = file
            self.line = line
        #endif
    }

    var wrappedValue: Value {
        mutating get {
            #if DEBUG
                precondition(_value != nil, "This property must be inject before access", file: file, line: line)
            #endif
            return _value
        }
        set {
            #if DEBUG
                precondition(_value == nil, "This property is actcully a LET property", file: file, line: line)
            #endif
            _value = newValue
        }
    }
}
