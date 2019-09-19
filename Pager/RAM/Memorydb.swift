//
//  Memorydb.swift
//  Pager
//
//  Created by darys on 11.01.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import Foundation

struct Memorydb {
    let id: Int64?
    var mem: String
    var a: String
    var b: String
    var c: String
    var d: String
    var e: String
    var f: String
    
    
    //MARK: Inicjalizacja
    init(id: Int64) {
        self.id = id
        mem = ""
        a = ""
        b = ""
        c = ""
        d = ""
        e = ""
        f = ""
    }
    
    init?(id: Int64, mem: String,  a: String, b: String, c: String, d: String, e: String, f: String){
        self.id = id
        self.mem = mem
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
        self.f = f
    }
    
}
