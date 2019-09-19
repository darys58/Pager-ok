//
//  Podkategoriedb.swift
//  Pager
//
//  Created by darys on 17.03.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import Foundation

struct Podkategoriedb {
    let id: Int64?
    var pkid: String
    var kolejnosc: String
    var kaid: String
    var nazwa: String
    
    
    //MARK: Inicjalizacja
    init(id: Int64) {
        self.id = id
        pkid = ""
        kolejnosc = ""
        kaid = ""
        nazwa = ""
    }
    
    init?(id: Int64, pkid: String, kolejnosc: String, kaid: String, nazwa: String){
        self.id = id
        self.pkid = pkid
        self.kolejnosc = kolejnosc
        self.kaid = kaid
        self.nazwa = nazwa
    }
    
}
