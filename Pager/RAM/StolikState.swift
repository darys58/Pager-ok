//
//  StolikState.swift
//  Pager
//
//  Created by darys on 01.06.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import Foundation

struct DanieNaStole: Decodable{
    let st_id: String
    let st_uz_id: String
    let st_re_id: String
    let da_id: String
    var da_nazwa: String
    var da_opis: String
    var st_ile: String
    var st_cena: String
    var st_waga: String
    var st_kcal: String
}

struct DanieZamowione: Decodable{
    var zm_ile: String
    var zm_nazwa: String
    var zm_cena: String
}

struct DaniaRazem: Decodable{
    var cena_s: String
    var waga_s: String
    var kcal_s: String
    var koszt_opakowan:String
}

struct Zamowienie: Decodable{
    let za_id: String
    var za_typ: String
    var za_typ_text: String
    var za_data: String
    var za_odp3: String
    var za_odp4: String
    var za_godz: String
    var za_adres: String
    var za_numer: String
    var za_kod: String
    var za_miasto: String
    var za_miejsc: String
    var za_czas: String
    var za_imie: String
    var za_nazwisko: String
    var za_telefon: String
    var za_email: String
    var za_uwagi: String
    var za_platnosc: String
    var za_koszt: String
    var za_moge: String
    var za_lang: String
    var cena_razem: String
    var za_status_id: String
    var za_status: String
}

struct User: Decodable{
    var uz_email: String
    var uz_student: String
    var uz_au_id: String
    var au_zboza: String
    var au_skorupiaki: String
    var au_jaja: String
    var au_ryby: String
    var au_o_ziemne: String
    var au_soja: String
    var au_mleko: String
    var au_orzechy: String
    var au_seler: String
    var au_gorczyca: String
    var au_sezam: String
    var au_siarczany: String
    var au_lubin: String
    var au_mieczaki: String
}

struct Powiadomienie: Decodable{
    var rb_id: String
    var rb_re_id: String
    var rb_resta: String
    var rb_mia_id: String
    var rb_da_id: String
    var rb_tytul: String
    var rb_opis: String
    var rb_data_mod: String
}

struct Strefa: Decodable{
    var czynne: String
    var zamow_od: String
    var zamow_do: String
    var str_numer: String
    var str_zakres: String
    var str_wart_min: String
    var str_koszt: String
    var str_wart_max: String
    var str_koszt_bonus: String
    var re_platne_dos: String
}
