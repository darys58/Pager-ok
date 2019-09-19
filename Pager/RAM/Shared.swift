//
//  Shared.swift
//  Pager
//
//  Created by darys on 13.01.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import Foundation

//pamięć podręczna
final class Shared{
    static let shared = Shared()
    let mojSzary = UIColor(red:250/255, green:250/255, blue:250/255, alpha:1.0)
    let malinaColor = UIColor(red:216/255, green:67/255, blue:78/255, alpha:1.0)
    let malinaColorLight = UIColor(red:209/255, green:137/255, blue:137/255, alpha:0.6)
    let mojeyellow = UIColor(red:255/255, green:224/255, blue:0/255, alpha:1.0)
    let status0 = UIColor(red:214/255, green:234/255, blue:248/255, alpha:1.0)
    let status1 = UIColor(red:252/255, green:243/255, blue:207/255, alpha:1.0)
    let status2_3_31 = UIColor(red:209/255, green:242/255, blue:235/255, alpha:1.0)
    let status4_5_51 = UIColor(red:250/255, green:219/255, blue:216/255, alpha:1.0)
    let status6_7_71 = UIColor.white
    let status80 = UIColor.lightGray
    let status90 = UIColor.white
    
    var lang: String!               //symbol języka  np: pl
//    var adult: String!                //"tak" lub "nie"
    var alergeny: [String]!         //lista wszystkich alergenów w daniu
    var lista_wersji: [String]!   //lista z JSONa
    var wyborIdWersja: Int!         //wybrany wariant dania (index z listy wersji)
    var lista_wariant1: [String]!   //lista z JSONa
    var lista_wariant2: [String]!   //lista z JSONa
    var wyborIdWariant1: Int!     //index listy dod. wariant 1 i 2 z JSONa jeżeli był ulubiony (w do_wariant)
    var wyborIdWariant2: Int!     //lub z list odpowiednio w Pop1ViewController i Pop2ViewController
    var wyborIdDodatkowe: [Int]!    //wybrane dodatki dodatkowe w Tab1ViewController
    var restauracje: [MealResta]!   //lista restauracji w których dostępne jest danie
    var na_stoliku: Int!             //ilość tego dania na stoliku
    var sklad: [MealSklad]!         //lista składników dania
    var opinie: [MealOpinie]!       //opinie o daniu
    var moje_opinie: [MealOpinie]!  //opinie zalogowanego o daniu
    var moja_opinia: MealOpinie! //opinia zalogowanego wybrana do edycji
    var facilities_rest_index: Int! //index restauracji przy wyświetleniu udogodnień
    var temp: Int!          //0 - można podkategorie, 1 - blokada podkategorii (żeby był tylko jeden popup )
    var podkategoria: String! //identyfikator podkategorii aktualnie wybranej w popupie (na liscie dań)
    var lista: String!      //1 - lista z opisami dania, 2 - lista ze zdjęciami dań
    var ostrzezenia: String! //1 - ostrzeżenia włączone, 2 - bez ostrzeżeń
    var uz_id: String!      //id zalogowaneg
    var uz_login: String!   //login zalogowanego
    var uz_email: String!   //email zalogowanego
    var uz_student: String! //"1" - student, "0" - niestudent
    var rodzaje:[RodzajSk]! //lista kategorii(rodzajów) składników z ocenami dla zalogowanego
    var rd_id: Int! //id wybranej kategorii składnika w RodzajeViewController (do oceny nazw)
    var rd_rodzaj: String! //nazwa wybranej kategorii składnika w RodzajeViewController (do oceny nazw)
    var nazwy:[NazwaSk]! //lista nazw składników w wybranej kategorii z ocenami dla zalogowanego
    var nd_id: Int! //id wybranej nazwy składnika w NazwyViewController (do oceny form)
    var nd_nazwa: String! //nazwa składnika w NazwyViewController (do oceny form)
    var formy:[FormaSk]! //lista form składników dla wybranej nazwy z oceną dla zalogowanego
    //var do_id: Int! //id wybranej formy składnika w FormyViewController (ocena konkretnego składnika)
    var stolik: [DanieNaStole]! //lista dań na stoliku
    var dostawa: Int! //0 - dostawa, 1 - odbiór własny
    var cenaRazem: String! //cena razem zamówienia (dostawy lub do stolika)
    var kosztOpakowan: String! //koszt opakowań przy dostawie
    var akceptuje: String! //"tak" lub "nie"
    var adres: String! //adres dostawy
    var numer: String! //numer mieszkania dostawy
    var kod: String!    //kod pocztowy lub kod stolika
    var miasto: String!
    var imie: String!
    var nazwisko: String!
    var telefon: String!
    var email: String!
    var koszt: String! //koszt dostawy
    var dolaczMenu: String! //0 - nie dołączaj menu, 1 - dołącz menu (przy rezerwacji stolika)
    var data: String! //rezerwacji stolika
    var godzina: String! //rezerwacji stolika
    var miejsc: String! //przy rezerwacji stolika
    var pobyt: String! //przy rezerwacji stolika
    var mogeJesc: String! //1 - możliwa opcja "Mogę jeść", 0 - brak takiej możliwości
    var czasMogeJesc: String! //godzina z opcji "moge jeść"
    var zamowienia: [Zamowienie]! //lista zamówień użytkownika
    var selectedIdZamowienia: String! //id wybranego zamówienia do wyświetlenia szczegółów
    var zamowioneDania: [DanieZamowione]! //lista dań dla wybranego zamówienia w jego szczegółach
    //var alergik = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0"] //tablica reakcji na alergeny dla zalogowanego (0,1,2)
    var alergik_temp = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0"] //tablica tymczasowa - potrzebna przy zapisie
    var user: [User]! //dane zalogowanego (email, student, alergeny)
    var powiadomienia: [Powiadomienie]! //reklamy jako powiadomienia dla restauracji lub miasta
    var kod_stolika: String! //kod stolika wczytany z QR kodu
    var strefy: [Strefa]! //lista stref dostawy dla wybranej aktualnie restauracji
    var strefa: Int! //numer strefy: 0 - Strefa 1, 1 - Strefa 2 itd.
    var platnosc: Int! //sposób zapłaty 0 - Gotówka, 1 - Karta, 2 - Internet
    var ileDanJSON: Int! //ilość dań do pobierania w funkcji "importujDania" w Network.swift
    var ileRestaJSON: Int! //ilość restauracji do pobierania w funkcji "importujRestauracje" 
    var liczDania: Int! //licznik pobranych dań w funkcji "importujDania"
    var liczResta: Int! //licznik pobranych restauracji w funkcji "importujRestauracje"
    var czy_rest: Int! //0 - lista dań dla restauracji, 1 - lista dań dla miasta, 
}
