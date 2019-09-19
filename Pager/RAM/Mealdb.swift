//
//  Mealdb.swift
//  Pager
//
//  Created by darys on 17.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//


import UIKit

struct Mealdb {     //format danych dania przechowywanych w tabeli "dania" w bazie lokalnej aplikacji
    let id: Int64?
    var daid: String
    var nazwa: String
    var opis: String
    var idwer: String
    var wersja: String
    var foto: String
    var gdzie: String
    var kategoria: String
    var podkat: String
    var srednia: String
    var alergeny: String
    var cena: String
    var czas: String
    var waga: String
    var kcal: String
    var lubi: String
    var fav: String
    
    
    //MARK: Inicjalizacja
    init() {
        id = 0
        daid = ""
        nazwa = ""
        opis = ""
        idwer = ""
        wersja = ""
        foto = ""
        gdzie = ""
        kategoria = ""
        podkat = ""
        srednia = ""
        alergeny = ""
        cena = ""
        czas = ""
        waga = ""
        kcal = ""
        lubi = ""
        fav = ""
    }
    
    init(id: Int64) {
        self.id = id
        daid = ""
        nazwa = ""
        opis = ""
        idwer = ""
        wersja = ""
        foto = ""
        gdzie = ""
        kategoria = ""
        podkat = ""
        srednia = ""
        alergeny = ""
        cena = ""
        czas = ""
        waga = ""
        kcal = ""
        lubi = ""
        fav = ""
    }
    
    init?(id: Int64, daid: String, nazwa: String, opis: String, idwer: String, wersja: String, foto: String, gdzie: String, kategoria: String, podkat: String, srednia: String, alergeny: String, cena: String, czas: String, waga: String, kcal: String, lubi: String, fav: String){
        self.id = id
        self.daid = daid
        self.nazwa = nazwa
        self.opis = opis
        self.idwer = idwer
        self.wersja = wersja
        self.foto = foto
        self.gdzie = gdzie
        self.kategoria = kategoria
        self.podkat = podkat
        self.srednia = srednia
        self.alergeny = alergeny
        self.cena = cena
        self.czas = czas
        self.waga = waga
        self.kcal = kcal
        self.lubi = lubi
        self.fav = fav
    }
    
}



