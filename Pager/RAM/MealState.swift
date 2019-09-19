//
//  MealState.swift
//  Pager
//
//  Created by darys on 10.01.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import Foundation

//format danych szczegółowych dania pobieranych JSONem przez ios_danie.php
struct MealState: Decodable {
    let da_id: String
    let da_nazwa: String
    let da_opis: String
    let cena: String
    let da_czas: String
    let waga: Int
    let kcal: Int
    let da_lubi: Int
    let na_stoliku: Int
    let alergeny:[String] //wszystkie alergeny (a nie zalogowanego)
    let da_srednia: String
    let cena_podst: String
    let da_waga_podst: String
    let da_kcal_podst: String
    let da_id_lista_wer:[String]    //lista id dań poszczególnych wersji
    let da_wersja_lista:[String]    //lista nazw wersji dania
    let do_wariant: [String]        //dodatek wariantowy 1 i 2 ulubiony
    let do_wariant_lista1: [String]
    let do_wariant_lista2: [String]
    let do_dodat: [String]
    let do_podst_id: [String]
    let do_wariant_id: [String]     //id dodatku wariantowego 1 i 2 ulubionego
    let do_wariant_lista1_id: [String]
    let do_wariant_lista2_id: [String]
    let do_dodat_id: [String]
    let do_wariant_lista1_waga: [String]
    let do_wariant_lista2_waga: [String]
    let do_dodat_waga: [String]
    let do_wariant_lista1_kcal: [String]
    let do_wariant_lista2_kcal: [String]
    let do_dodat_kcal: [String]
    let do_wariant_lista1_cena: [String]
    let do_wariant_lista2_cena: [String]
    let do_dodat_cena: [String]
}

//format danych szczegółowych restauracji pobieranych JSONem przez ios_danie_resta.php
struct MealResta: Decodable {
    let re_logo: String
    let re_nazwa: String
    let re_obiekt: String
    let re_adres: String
    let re_kod: String
    let re_miasto: String
    let re_woj: String
    let re_tel1:String
    let re_tel2: String
    let re_email: String
    let re_www: String
    let re_gps: String
    let re_pon_od:Float  //zamienić na stringi do wytłuszania dnia 
    let re_pon_do:Float   //narazie te godziny sa nieużywane
    let re_wto_od:Float     //bo to "czy czynne"  pobieram ze strefami
    let re_wto_do:Float     //a wytłuszczanie nie wiem jak zrobić
    let re_sro_od:Float
    let re_sro_do:Float
    let re_czw_od:Float
    let re_czw_do:Float
    let re_pia_od:Float
    let re_pia_do:Float
    let re_sob_od:Float
    let re_sob_do:Float
    let re_nie_od:Float
    let re_nie_do:Float
    let re_otwarte_a: String 
    let re_otwarte_b: String
    let re_otwarte_c: String
    let cena: String
    let re_parking: String
    let re_podjazd: String
    let re_na_wynos: String
    let re_p_karta: String
    let re_s_zabaw: String
    let re_o_letni: String
    let re_klima: String
    let re_wifi: String
}

//format danych składników dania pobieranych JSONem przez ios_danie_sklad.php
struct MealSklad: Decodable {
    let do_id: String
    let do_rd_id: String
    let nd_nazwa: String
    let fd_forma: String
    let dd_da_id: String
    let do_kcal100: String
    var ud_lubi: String
}

//format danych składników dania pobieranych JSONem przez ios_danie_opinie.php
struct MealOpinie: Decodable {
    let op_id: String
    let op_da_id: String
    let op_autor: String
    let op_uz_id: String
    let op_tytul: String
    let op_tresc: String
    let op_wyglad: String
    let op_smak: String
    let op_zapach: String
    let op_temp: String
    let op_ilosc: String
    let op_cena: String
    let op_opis: String
    let op_foto: String
    let op_srednia: String
    let op_cobytu: String
    let op_data_dod: String
}
