//
//  Restaurantdb.swift
//  Pager
//
//  Created by darys on 30.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit

struct Restaurantdb {
    let id: Int64?
    var reid: String
    var nazwa: String
    var obiekt: String
    var adres: String
    var mia_id: String
    var miasto: String
    var woj_id: String
    var woj: String
    var dos: String
    var opak: String
    var do_st: String
    var rez: String
    var moge: String
    
    
    //MARK: Inicjalizacja
    init(id: Int64) {
        self.id = id
        reid = ""
        nazwa = ""
        obiekt = ""
        adres = ""
        mia_id = ""
        miasto = ""
        woj_id = ""
        woj = ""
        dos = ""
        opak = ""
        do_st = ""
        rez = ""
        moge = ""
    }
    
    init?(id: Int64, reid: String, nazwa: String, obiekt: String, adres: String, mia_id: String, miasto: String, woj_id: String, woj: String, dos: String, opak: String, do_st: String, rez: String, moge: String){
        self.id = id
        self.reid = reid
        self.nazwa = nazwa
        self.obiekt = obiekt
        self.adres = adres
        self.mia_id = mia_id
        self.miasto = miasto
        self.woj_id = woj_id
        self.woj = woj
        self.dos = dos
        self.opak = opak
        self.do_st = do_st
        self.rez = rez
        self.moge = moge
    }
    
}
