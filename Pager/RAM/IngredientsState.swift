//
//  IngredientsState.swift
//  Pager
//
//  Created by darys on 07.05.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import Foundation

struct RodzajSk: Decodable{
    let rd_id: Int
    let rd_rodzaj: String
    let total: Int
    var do_oceny: Int
    var o01: Int
    var o02: Int
    var o03: Int
    var o04: Int
    var o05: Int
    var o06: Int
    var o07: Int
    var o08: Int
    var o09: Int
    var o10: Int
    let rd_ocena: Int
}

struct NazwaSk: Decodable{
    let nd_id: Int
    let nd_nazwa: String
    let nd_total: Int
    var nd_do_oceny: Int
    var no01: Int
    var no02: Int
    var no03: Int
    var no04: Int
    var no05: Int
    var no06: Int
    var no07: Int
    var no08: Int
    var no09: Int
    var no10: Int
    let nd_ocena: Int
}

struct FormaSk: Decodable{
    let fd_id: Int
    let fd_forma: String
    let do_id: Int
    let do_kcal100: Int
    var ud_lubi: Int
}
