//
//  ActiveRecord.swift
//  Swifter
//  Copyright (c) 2014 Damian Kołakowski. All rights reserved.
//

import Foundation

struct SwifterActiveRecordField {
    var name: String? = "unknonw"
}

struct Test {
  var a: String = ""
}

protocol WithInit {
    init()
}

class SwifterActiveRecord<T: WithInit> {
    
    init() {

    }
    
    private func scheme(error: NSErrorPointer?) -> [SwifterActiveRecordField] {
        var results = [SwifterActiveRecordField]()
        let classInfoDump = reflect(T())
        for var index = 1; index < classInfoDump.count; ++index {
            let field = classInfoDump[index]
            var s = SwifterActiveRecordField(name: field.0)
        }
        return results
    }
    
    class func find(T -> Bool) -> [T] {
        return []
    }
    
    class func all() -> Array<String> {
        return []
    }
    
    func commit(error: NSErrorPointer) -> Bool {
        return false
    }
}


