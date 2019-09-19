//
//  ZamowViewController.swift
//  Pager
//
//  Created by darys on 22.06.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Localize_Swift

class ZamowViewController: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    
    var zamowienie = [Zamowienie]()  //dane zamówienia
    var offset = 0 //offset o wysokość przycisku lub/i opcji moge jeść
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var zamZam = [Zamowienie]()  //tablica zamówień
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tytuł ekranu
        let titlelabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel1
        titlelabel1.text = "L_SZCZEGOLY_ZAMOWIENIA".localized()
        titlelabel1.textAlignment = .center
        
        //pobranie danych zmówienia z pamici podręcznej
        for zam in Shared.shared.zamowienia{
            if zam.za_id == Shared.shared.selectedIdZamowienia{
                zamowienie.append(zam)  // wybrane zamówienie
            }
        }
        
        //kolor tła zamówienia
        switch zamowienie[0].za_status_id{
            case "0": myScrollView.backgroundColor = Shared.shared.status0
            case "1": myScrollView.backgroundColor = Shared.shared.status1
            case "2": myScrollView.backgroundColor = Shared.shared.status2_3_31
            case "3": myScrollView.backgroundColor = Shared.shared.status2_3_31
            case "31": myScrollView.backgroundColor = Shared.shared.status2_3_31
            case "4": myScrollView.backgroundColor = Shared.shared.status4_5_51
            case "5": myScrollView.backgroundColor = Shared.shared.status4_5_51
            case "51": myScrollView.backgroundColor = Shared.shared.status4_5_51
            case "6": myScrollView.backgroundColor = Shared.shared.status6_7_71
            case "7": myScrollView.backgroundColor = Shared.shared.status6_7_71
            case "71": myScrollView.backgroundColor = Shared.shared.status6_7_71
            case "80": myScrollView.backgroundColor = Shared.shared.status80
            case "90": myScrollView.backgroundColor = Shared.shared.status90
            default:
                myScrollView.backgroundColor = Shared.shared.status90
        }
        
        //--------------
        //Dostawa
        //--------------
        if zamowienie[0].za_typ == "1" { //jeżeli dostawa
            
            //typ zamówienia - podkład
            let pole = UIView(frame: CGRect(x: 10, y: 10, width: Int(self.view.frame.size.width - 20), height: 40))
            pole.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(pole)
            //typ zamówienia - text
            let typLabel = UILabel(frame: CGRect(x: 20, y: 15, width: Int(self.view.frame.size.width - 40), height: 30))
            typLabel.text = "L_DOSTAWA_Z_REST".localized()
            typLabel.textColor = UIColor.darkGray
            typLabel.font = UIFont.systemFont(ofSize: 16)
            self.myScrollView.addSubview(typLabel)
            
            //status zamówienia - label
            let statusLabel = UILabel(frame: CGRect(x: 10, y: 60, width: 70, height: 30))
            statusLabel.text = "L_STATUS".localized() + ":"
            statusLabel.textColor = UIColor.darkGray
            statusLabel.font = UIFont.systemFont(ofSize: 16)
            statusLabel.textAlignment = .right
            self.myScrollView.addSubview(statusLabel)
            //status zamówienia - wartość
            let statusText = UILabel(frame: CGRect(x: 90, y: 60, width: Int(self.view.frame.size.width - 105), height: 30))
            statusText.text = zamowienie[0].za_status
            statusText.textColor = UIColor.darkGray
            statusText.font = UIFont.boldSystemFont(ofSize: 16)
            self.myScrollView.addSubview(statusText)
            
            //odpowiedź z restauracji - label
            let odp3Label = UILabel(frame: CGRect(x: 10, y: 85, width: 70, height: 45))
            odp3Label.text = "L_ODPOWIEDZ".localized() + ":"
            odp3Label.textColor = UIColor.darkGray
            odp3Label.font = UIFont.systemFont(ofSize: 14)
            odp3Label.textAlignment = .right
            self.myScrollView.addSubview(odp3Label)
            //treść odpowiedzi
            let odp3Text = UILabel(frame: CGRect(x: 90, y: 85, width: Int(self.view.frame.size.width - 105), height: 45))
            odp3Text.text = zamowienie[0].za_odp3
            odp3Text.textColor = UIColor.darkGray
            odp3Text.font = UIFont.systemFont(ofSize: 14)
            odp3Text.numberOfLines = 2
            //odp3Text.isScrollEnabled = false
            //odp3Text.isEditable = false
            self.myScrollView.addSubview(odp3Text)
       
        
            //data zamówienia - label
            let dataLabel = UILabel(frame: CGRect(x: 10, y: 120, width: 70, height: 30))
            dataLabel.text = "L_DATA".localized() + ":"
            dataLabel.textColor = UIColor.darkGray
            dataLabel.font = UIFont.systemFont(ofSize: 14)
            dataLabel.textAlignment = .right
            self.myScrollView.addSubview(dataLabel)
            //data zamówienia - wartość
            let dataText = UILabel(frame: CGRect(x: 90, y: 120, width: Int(self.view.frame.size.width - 105), height: 30))
            dataText.text = zamowienie[0].za_data + " " + "L_NA_GODZ".localized() + " " + zamowienie[0].za_godz
            dataText.textColor = UIColor.darkGray
            dataText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(dataText)
            
            //adres zamówienia - label
            let adresLabel = UILabel(frame: CGRect(x: 10, y: 145, width: 70, height: 30))
            adresLabel.text = "L_ADRES".localized() + ":"
            adresLabel.textColor = UIColor.darkGray
            adresLabel.font = UIFont.systemFont(ofSize: 14)
            adresLabel.textAlignment = .right
            self.myScrollView.addSubview(adresLabel)
            //data zamówienia - wartość
            let adresText = UILabel(frame: CGRect(x: 90, y: 145, width: Int(self.view.frame.size.width - 105), height: 30))
            adresText.text = zamowienie[0].za_adres + " " + zamowienie[0].za_numer
            adresText.textColor = UIColor.darkGray
            adresText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(adresText)
            
            //miasto zamówienia - label
            let miastoLabel = UILabel(frame: CGRect(x: 10, y: 170, width: 70, height: 30))
            miastoLabel.text = "L_MIASTO".localized() + ":"
            miastoLabel.textColor = UIColor.darkGray
            miastoLabel.font = UIFont.systemFont(ofSize: 14)
            miastoLabel.textAlignment = .right
            self.myScrollView.addSubview(miastoLabel)
            //data zamówienia - wartość
            let miastoText = UILabel(frame: CGRect(x: 90, y: 170, width: Int(self.view.frame.size.width - 105), height: 30))
            miastoText.text = zamowienie[0].za_kod + "  " + zamowienie[0].za_miasto
            miastoText.textColor = UIColor.darkGray
            miastoText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(miastoText)
            
            //nazwisko zamówienia - label
            let nazwiskoLabel = UILabel(frame: CGRect(x: 10, y: 195, width: 70, height: 30))
            nazwiskoLabel.text = "L_NAZWISKO".localized() + ":"
            nazwiskoLabel.textColor = UIColor.darkGray
            nazwiskoLabel.font = UIFont.systemFont(ofSize: 14)
            nazwiskoLabel.textAlignment = .right
            self.myScrollView.addSubview(nazwiskoLabel)
            //data zamówienia - wartość
            let nazwiskoText = UILabel(frame: CGRect(x: 90, y: 195, width: Int(self.view.frame.size.width - 105), height: 30))
            nazwiskoText.text = zamowienie[0].za_imie + " " + zamowienie[0].za_nazwisko
            nazwiskoText.textColor = UIColor.darkGray
            nazwiskoText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(nazwiskoText)
            
            //telefon zamówienia - label
            let telefonLabel = UILabel(frame: CGRect(x: 10, y: 220, width: 70, height: 30))
            telefonLabel.text = "L_TELEFON".localized() + ":"
            telefonLabel.textColor = UIColor.darkGray
            telefonLabel.font = UIFont.systemFont(ofSize: 14)
            telefonLabel.textAlignment = .right
            self.myScrollView.addSubview(telefonLabel)
            //data zamówienia - wartość
            let telefonText = UILabel(frame: CGRect(x: 90, y: 220, width: Int(self.view.frame.size.width - 105), height: 30))
            telefonText.text = zamowienie[0].za_telefon
            telefonText.textColor = UIColor.darkGray
            telefonText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(telefonText)
            
            //email zamówienia - label
            let emailLabel = UILabel(frame: CGRect(x: 10, y: 245, width: 70, height: 30))
            emailLabel.text = "L_EMAIL".localized() + ":"
            emailLabel.textColor = UIColor.darkGray
            emailLabel.font = UIFont.systemFont(ofSize: 14)
            emailLabel.textAlignment = .right
            self.myScrollView.addSubview(emailLabel)
            //data zamówienia - wartość
            let emailText = UILabel(frame: CGRect(x: 90, y: 245, width: Int(self.view.frame.size.width - 105), height: 30))
            emailText.text = zamowienie[0].za_email
            emailText.textColor = UIColor.darkGray
            emailText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(emailText)
            
            //uwagi zamówienia - label
            let uwagiLabel = UILabel(frame: CGRect(x: 10, y: 270, width: 70, height: 45))
            uwagiLabel.text = "L_UWAGI".localized() + ":"
            uwagiLabel.textColor = UIColor.darkGray
            uwagiLabel.font = UIFont.systemFont(ofSize: 14)
            uwagiLabel.textAlignment = .right
            self.myScrollView.addSubview(uwagiLabel)
            //data zamówienia - wartość
            let uwagiText = UILabel(frame: CGRect(x: 90, y: 270, width: Int(self.view.frame.size.width - 105), height: 45))
            uwagiText.text = zamowienie[0].za_uwagi
            uwagiText.textColor = UIColor.darkGray
            uwagiText.font = UIFont.systemFont(ofSize: 14)
            uwagiText.numberOfLines = 2
            self.myScrollView.addSubview(uwagiText)
            
            //zamówione menu - podkład
            let pole1 = UIView(frame: CGRect(x: 10, y: 315, width: Int(self.view.frame.size.width - 20), height: 40))
            pole1.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(pole1)
            //zamówione menu - text
            let menuLabel = UILabel(frame: CGRect(x: 20, y: 320, width: Int(self.view.frame.size.width - 40), height: 30))
            menuLabel.text = "L_ZAMOWIONE_MENU".localized()
            menuLabel.textColor = UIColor.darkGray
            menuLabel.font = UIFont.systemFont(ofSize: 16)
            self.myScrollView.addSubview(menuLabel)
            
            
            //płatność - label
            let platnoscLabel = UILabel(frame: CGRect(x: 10, y: 360, width: 70, height: 30))
            platnoscLabel.text = "L_PLATNOSC".localized() + ":"
            platnoscLabel.textColor = UIColor.darkGray
            platnoscLabel.font = UIFont.systemFont(ofSize: 14)
            platnoscLabel.textAlignment = .right
            self.myScrollView.addSubview(platnoscLabel)
            //data zamówienia - wartość
            let platnoscText = UILabel(frame: CGRect(x: 90, y: 360, width: Int(self.view.frame.size.width - 105), height: 30))
            switch zamowienie[0].za_platnosc{
                case "0": platnoscText.text = "L_BRAK_DANYCH".localized()
                case "1": platnoscText.text = "L_GOTOWKA".localized()
                case "2": platnoscText.text = "L_KARTA".localized()
                case "3": platnoscText.text = "L_ONLINE".localized()
                default: break;
            }
            platnoscText.textColor = UIColor.darkGray
            platnoscText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(platnoscText)
            
            
            //wyświetlwnie zamówionych dań 
            var i = 0
            for dan in Shared.shared.zamowioneDania{
                let linia = UIView(frame: CGRect(x: 16, y: 395 + (30 * i), width: Int(self.view.frame.size.width - 32), height: 1))
                linia.backgroundColor = UIColor.lightGray
                self.myScrollView.addSubview(linia)
                //ilość i nazwa dania
                let danie = UILabel(frame: CGRect(x: 20, y: 395 + (30 * i), width: Int(self.view.frame.size.width - 120), height: 30))
                danie.text = dan.zm_ile + " x " + dan.zm_nazwa
                danie.textColor = UIColor.darkGray
                danie.font = UIFont.systemFont(ofSize: 14)
                //danie.lineBreakMode = .byWordWrapping
                //danie.numberOfLines = 3
                self.myScrollView.addSubview(danie)
                //cena dania
                let cena = UILabel(frame: CGRect(x: Int(self.view.frame.size.width - 116), y: 395 + (30 * i), width: 100, height: 30))
                
                //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
                let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                let numCena = formatter1.string(from: NSNumber(value: Float(dan.zm_cena)!))

                cena.text = numCena! + " " + "L_PLN".localized()
                cena.textColor = UIColor.darkGray
                cena.font = UIFont.systemFont(ofSize: 14)
                cena.textAlignment = .right
                self.myScrollView.addSubview(cena)
                i += 1
            }
            
            //wyswietlenie kosztów dostawy i ceny razem
            var koszty = "0.00"
            var razem = "0.00"
            for zam in Shared.shared.zamowienia{
                if zam.za_id == Shared.shared.selectedIdZamowienia {
                    koszty = zam.za_koszt
                    razem = zam.cena_razem
                }
            }
            //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
            let formatter1 = NumberFormatter() //deklaracja obiektu formatera
            formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
            formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
            let numKoszty = formatter1.string(from: NSNumber(value: Float(koszty)!))
            let numRazem = formatter1.string(from: NSNumber(value: Float(razem)!))
            
            let linia = UIView(frame: CGRect(x: 16, y: 395 + (30 * i), width: Int(self.view.frame.size.width - 32), height: 1))
            linia.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(linia)
            //koszty dostawy
            let danie = UILabel(frame: CGRect(x: 20, y: 395 + (30 * i), width: Int(self.view.frame.size.width - 120), height: 30))
            danie.text = "L_KOSZT_DOSTAWY".localized()
            danie.textColor = UIColor.darkGray
            danie.font = UIFont.systemFont(ofSize: 14)
            //danie.lineBreakMode = .byWordWrapping
            //danie.numberOfLines = 3
            self.myScrollView.addSubview(danie)
            //cena dania
            let cena = UILabel(frame: CGRect(x: Int(self.view.frame.size.width - 116), y: 395 + (30 * i), width: 100, height: 30))
            cena.text = numKoszty! + " " + "L_PLN".localized()
            cena.textColor = UIColor.darkGray
            cena.font = UIFont.systemFont(ofSize: 14)
            cena.textAlignment = .right
            self.myScrollView.addSubview(cena)
            i += 1
            
            let linia1 = UIView(frame: CGRect(x: 16, y: 395 + (30 * i), width: Int(self.view.frame.size.width - 32), height: 1))
            linia1.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(linia1)
            //razem
            let cenaRazem = UILabel(frame: CGRect(x: 20, y: 395 + (30 * i), width: Int(self.view.frame.size.width - 120), height: 30))
            cenaRazem.text = "L_RAZEM".localized()
            cenaRazem.textColor = UIColor.darkGray
            cenaRazem.font = UIFont.boldSystemFont(ofSize: 14)
            self.myScrollView.addSubview(cenaRazem)
            //cena dania
            let cenaWartosc = UILabel(frame: CGRect(x: Int(self.view.frame.size.width - 116), y: 395 + (30 * i), width: 100, height: 30))
            cenaWartosc.text = numRazem! + " " + "L_PLN".localized()
            cenaWartosc.textColor = UIColor.darkGray
            cenaWartosc.font = UIFont.boldSystemFont(ofSize: 14)
            cenaWartosc.textAlignment = .right
            self.myScrollView.addSubview(cenaWartosc)
            i += 1
            
            let linia2 = UIView(frame: CGRect(x: 16, y: 395 + (30 * i), width: Int(self.view.frame.size.width - 32), height: 1))
            linia2.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(linia2)
            
            if zamowienie[0].za_status_id == "0" || zamowienie[0].za_status_id == "1"{
                //przycisk "rezygnuję"
                offset = 60
                let rezygnujeButton = UIButton.init(type: .system)
                rezygnujeButton.frame = CGRect(x: 10, y: 395 + (30 * i) + 20, width: Int(self.view.frame.size.width - 20), height: 40)
                rezygnujeButton.setTitle("L_REZYGNUJE".localized(), for: .normal)
                rezygnujeButton.titleLabel?.textColor = UIColor.white
                rezygnujeButton.tintColor = UIColor.white
                rezygnujeButton.layer.cornerRadius = 5.0
                rezygnujeButton.backgroundColor = UIColor.gray
                rezygnujeButton.addTarget(self, action: #selector(buttonRezygnujeClic(_ :)), for: .touchUpInside)
                self.myScrollView.addSubview(rezygnujeButton)
                
                
            }
            
            //ustalenie wysokości myScrollView
             myScrollView.contentSize = CGSize(width: Int(self.view.frame.size.width), height: 395 + (30 * i) + 20 + offset)
        
        } //dostawa
        
        //--------------
        //Do stolika
        //--------------
        if zamowienie[0].za_typ == "2" { //jeżeli zamówienie do stolika
            
            //typ zamówienia - podkład
            let pole = UIView(frame: CGRect(x: 10, y: 10, width: Int(self.view.frame.size.width - 20), height: 40))
            pole.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(pole)
            //typ zamówienia - text
            let typLabel = UILabel(frame: CGRect(x: 20, y: 15, width: Int(self.view.frame.size.width - 40), height: 30))
            typLabel.text = "L_DO_STOLIKA".localized()
            typLabel.textColor = UIColor.darkGray
            typLabel.font = UIFont.systemFont(ofSize: 16)
            self.myScrollView.addSubview(typLabel)
            
            //status zamówienia - label
            let statusLabel = UILabel(frame: CGRect(x: 10, y: 60, width: 70, height: 30))
            statusLabel.text = "L_STATUS".localized() + ":"
            statusLabel.textColor = UIColor.darkGray
            statusLabel.font = UIFont.systemFont(ofSize: 16)
            statusLabel.textAlignment = .right
            self.myScrollView.addSubview(statusLabel)
            //status zamówienia - wartość
            let statusText = UILabel(frame: CGRect(x: 90, y: 60, width: Int(self.view.frame.size.width - 105), height: 30))
            statusText.text = zamowienie[0].za_status
            statusText.textColor = UIColor.darkGray
            statusText.font = UIFont.boldSystemFont(ofSize: 16)
            self.myScrollView.addSubview(statusText)
            
            //odpowiedź z restauracji - label
            let odp3Label = UILabel(frame: CGRect(x: 10, y: 85, width: 70, height: 45))
            odp3Label.text = "L_ODPOWIEDZ".localized() + ":"
            odp3Label.textColor = UIColor.darkGray
            odp3Label.font = UIFont.systemFont(ofSize: 14)
            odp3Label.textAlignment = .right
            self.myScrollView.addSubview(odp3Label)
            //treść odpowiedzi
            let odp3Text = UILabel(frame: CGRect(x: 90, y: 85, width: Int(self.view.frame.size.width - 105), height: 45))
            odp3Text.text = zamowienie[0].za_odp3
            odp3Text.textColor = UIColor.darkGray
            odp3Text.font = UIFont.systemFont(ofSize: 14)
            odp3Text.numberOfLines = 2
            //odp3Text.isScrollEnabled = false
            //odp3Text.isEditable = false
            self.myScrollView.addSubview(odp3Text)
            
            //data zamówienia - label
            let dataLabel = UILabel(frame: CGRect(x: 10, y: 120, width: 70, height: 30))
            dataLabel.text = "L_DATA".localized() + ":"
            dataLabel.textColor = UIColor.darkGray
            dataLabel.font = UIFont.systemFont(ofSize: 14)
            dataLabel.textAlignment = .right
            self.myScrollView.addSubview(dataLabel)
            //data zamówienia - wartość
            let dataText = UILabel(frame: CGRect(x: 90, y: 120, width: Int(self.view.frame.size.width - 105), height: 30))
            dataText.text = zamowienie[0].za_data
            dataText.textColor = UIColor.darkGray
            dataText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(dataText)
 
            //kod stolika - label
            let miastoLabel = UILabel(frame: CGRect(x: 10, y: 145, width: 70, height: 30))
            miastoLabel.text = "L_KOD".localized() + ":"
            miastoLabel.textColor = UIColor.darkGray
            miastoLabel.font = UIFont.systemFont(ofSize: 14)
            miastoLabel.textAlignment = .right
            self.myScrollView.addSubview(miastoLabel)
            //data zamówienia - wartość
            let miastoText = UILabel(frame: CGRect(x: 90, y: 145, width: Int(self.view.frame.size.width - 105), height: 30))
            miastoText.text = zamowienie[0].za_kod
            miastoText.textColor = UIColor.darkGray
            miastoText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(miastoText)
           
            
            //email zamówienia - label
            let emailLabel = UILabel(frame: CGRect(x: 10, y: 170, width: 70, height: 30))
            emailLabel.text = "L_EMAIL".localized() + ":"
            emailLabel.textColor = UIColor.darkGray
            emailLabel.font = UIFont.systemFont(ofSize: 14)
            emailLabel.textAlignment = .right
            self.myScrollView.addSubview(emailLabel)
            //data zamówienia - wartość
            let emailText = UILabel(frame: CGRect(x: 90, y: 170, width: Int(self.view.frame.size.width - 105), height: 30))
            emailText.text = zamowienie[0].za_email
            emailText.textColor = UIColor.darkGray
            emailText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(emailText)
            
            //uwagi zamówienia - label
            let uwagiLabel = UILabel(frame: CGRect(x: 10, y: 195, width: 70, height: 45))
            uwagiLabel.text = "L_UWAGI".localized() + ":"
            uwagiLabel.textColor = UIColor.darkGray
            uwagiLabel.font = UIFont.systemFont(ofSize: 14)
            uwagiLabel.textAlignment = .right
            self.myScrollView.addSubview(uwagiLabel)
            //data zamówienia - wartość
            let uwagiText = UILabel(frame: CGRect(x: 90, y: 195, width: Int(self.view.frame.size.width - 105), height: 45))
            uwagiText.text = zamowienie[0].za_uwagi
            uwagiText.textColor = UIColor.darkGray
            uwagiText.font = UIFont.systemFont(ofSize: 14)
            uwagiText.numberOfLines = 2
            self.myScrollView.addSubview(uwagiText)
            
            //zamówione menu - podkład
            let pole1 = UIView(frame: CGRect(x: 10, y: 245, width: Int(self.view.frame.size.width - 20), height: 40))
            pole1.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(pole1)
            //zamówione menu - text
            let menuLabel = UILabel(frame: CGRect(x: 20, y: 250, width: Int(self.view.frame.size.width - 40), height: 30))
            menuLabel.text = "L_ZAMOWIONE_MENU".localized()
            menuLabel.textColor = UIColor.darkGray
            menuLabel.font = UIFont.systemFont(ofSize: 16)
            self.myScrollView.addSubview(menuLabel)
            
            
            //wyświetlwnie zamówionych dań
            var i = 0
            for dan in Shared.shared.zamowioneDania{
                let linia = UIView(frame: CGRect(x: 16, y: 300 + (30 * i), width: Int(self.view.frame.size.width - 32), height: 1))
                linia.backgroundColor = UIColor.lightGray
                self.myScrollView.addSubview(linia)
                //ilość i nazwa dania
                let danie = UILabel(frame: CGRect(x: 20, y: 300 + (30 * i), width: Int(self.view.frame.size.width - 120), height: 30))
                danie.text = dan.zm_ile + " x " + dan.zm_nazwa
                danie.textColor = UIColor.darkGray
                danie.font = UIFont.systemFont(ofSize: 14)
                //danie.lineBreakMode = .byWordWrapping
                //danie.numberOfLines = 3
                self.myScrollView.addSubview(danie)
                //cena dania
                let cena = UILabel(frame: CGRect(x: Int(self.view.frame.size.width - 116), y: 300 + (30 * i), width: 100, height: 30))
                
                //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
                let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                let numCena = formatter1.string(from: NSNumber(value: Float(dan.zm_cena)!))

                cena.text = numCena! + " " + "L_PLN".localized()
                cena.textColor = UIColor.darkGray
                cena.font = UIFont.systemFont(ofSize: 14)
                cena.textAlignment = .right
                self.myScrollView.addSubview(cena)
                i += 1
            }
            
            //wyswietlenie kosztów dostawy i ceny razem
            //var koszty = "0.00"
            var razem = "0.00"
            for zam in Shared.shared.zamowienia{
                if zam.za_id == Shared.shared.selectedIdZamowienia {
                    //koszty = zam.za_koszt
                    razem = zam.cena_razem
                }
            }
            
    /*        let linia = UIView(frame: CGRect(x: 16, y: 300 + (30 * i), width: Int(self.view.frame.size.width - 32), height: 1))
            linia.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(linia)
            //koszty dostawy
            let danie = UILabel(frame: CGRect(x: 20, y: 300 + (30 * i), width: Int(self.view.frame.size.width - 120), height: 30))
            danie.text = "L_KOSZT_DOSTAWY".localized()
            danie.textColor = UIColor.darkGray
            danie.font = UIFont.systemFont(ofSize: 14)
            //danie.lineBreakMode = .byWordWrapping
            //danie.numberOfLines = 3
            self.myScrollView.addSubview(danie)
            //cena dania
            let cena = UILabel(frame: CGRect(x: Int(self.view.frame.size.width - 116), y: 300 + (30 * i), width: 100, height: 30))
            cena.text = "\(koszty) " + "L_PLN".localized()
            cena.textColor = UIColor.darkGray
            cena.font = UIFont.systemFont(ofSize: 14)
            cena.textAlignment = .right
            self.myScrollView.addSubview(cena)
            i += 1
    */
            let linia1 = UIView(frame: CGRect(x: 16, y: 300 + (30 * i), width: Int(self.view.frame.size.width - 32), height: 1))
            linia1.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(linia1)
            //razem
            let cenaRazem = UILabel(frame: CGRect(x: 20, y: 300 + (30 * i), width: Int(self.view.frame.size.width - 120), height: 30))
            cenaRazem.text = "L_RAZEM".localized()
            cenaRazem.textColor = UIColor.darkGray
            cenaRazem.font = UIFont.boldSystemFont(ofSize: 14)
            self.myScrollView.addSubview(cenaRazem)
            //cena dania
            let cenaWartosc = UILabel(frame: CGRect(x: Int(self.view.frame.size.width - 116), y: 300 + (30 * i), width: 100, height: 30))
            
            //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
            let formatter1 = NumberFormatter() //deklaracja obiektu formatera
            formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
            formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
            let numRazem = formatter1.string(from: NSNumber(value: Float(razem)!))
            
            cenaWartosc.text = numRazem! + " " + "L_PLN".localized()
            cenaWartosc.textColor = UIColor.darkGray
            cenaWartosc.font = UIFont.boldSystemFont(ofSize: 14)
            cenaWartosc.textAlignment = .right
            self.myScrollView.addSubview(cenaWartosc)
            i += 1
            
            let linia2 = UIView(frame: CGRect(x: 16, y: 300 + (30 * i), width: Int(self.view.frame.size.width - 32), height: 1))
            linia2.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(linia2)
            
            if zamowienie[0].za_status_id == "0" || zamowienie[0].za_status_id == "1"{
                //przycisk "rezygnuję"
                offset = 60
                let rezygnujeButton = UIButton.init(type: .system)
                rezygnujeButton.frame = CGRect(x: 10, y: 300 + (30 * i) + 20, width: Int(self.view.frame.size.width - 20), height: 40)
                rezygnujeButton.setTitle("L_REZYGNUJE".localized(), for: .normal)
                rezygnujeButton.titleLabel?.textColor = UIColor.white
                rezygnujeButton.tintColor = UIColor.white
                rezygnujeButton.layer.cornerRadius = 5.0
                rezygnujeButton.backgroundColor = UIColor.gray
                rezygnujeButton.addTarget(self, action: #selector(buttonRezygnujeClic(_ :)), for: .touchUpInside)
                self.myScrollView.addSubview(rezygnujeButton)
                
                
            }
            
            //ustalenie wysokośi myScrollView
            myScrollView.contentSize = CGSize(width: Int(self.view.frame.size.width), height: 300 + (30 * i) + 20 + offset)
            
        }// jeżeli "Do stolika"
        
        //-------------------
        //Rezerwacja stolika
        //-------------------
        if zamowienie[0].za_typ == "3" { //jeżeli rezerwacja stolika
            
            //typ zamówienia - podkład
            let pole = UIView(frame: CGRect(x: 10, y: 10, width: Int(self.view.frame.size.width - 20), height: 40))
            pole.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(pole)
            //typ zamówienia - text
            let typLabel = UILabel(frame: CGRect(x: 20, y: 15, width: Int(self.view.frame.size.width - 40), height: 30))
            typLabel.text = "L_REZERWACJA_STOL".localized()
            typLabel.textColor = UIColor.darkGray
            typLabel.font = UIFont.systemFont(ofSize: 16)
            self.myScrollView.addSubview(typLabel)
            
            //status zamówienia - label
            let statusLabel = UILabel(frame: CGRect(x: 10, y: 60, width: 70, height: 30))
            statusLabel.text = "L_STATUS".localized() + ":"
            statusLabel.textColor = UIColor.darkGray
            statusLabel.font = UIFont.systemFont(ofSize: 16)
            statusLabel.textAlignment = .right
            self.myScrollView.addSubview(statusLabel)
            //status zamówienia - wartość
            let statusText = UILabel(frame: CGRect(x: 90, y: 60, width: Int(self.view.frame.size.width - 105), height: 30))
            statusText.text = zamowienie[0].za_status
            statusText.textColor = UIColor.darkGray
            statusText.font = UIFont.boldSystemFont(ofSize: 16)
            self.myScrollView.addSubview(statusText)
            
            //odpowiedź z restauracji - label
            let odp3Label = UILabel(frame: CGRect(x: 10, y: 85, width: 70, height: 45))
            odp3Label.text = "L_ODPOWIEDZ".localized() + ":"
            odp3Label.textColor = UIColor.darkGray
            odp3Label.font = UIFont.systemFont(ofSize: 14)
            odp3Label.textAlignment = .right
            self.myScrollView.addSubview(odp3Label)
            //treść odpowiedzi
            let odp3Text = UILabel(frame: CGRect(x: 90, y: 85, width: Int(self.view.frame.size.width - 105), height: 45))
            odp3Text.text = zamowienie[0].za_odp3
            odp3Text.textColor = UIColor.darkGray
            odp3Text.font = UIFont.systemFont(ofSize: 14)
            odp3Text.numberOfLines = 2
            //odp3Text.isScrollEnabled = false
            //odp3Text.isEditable = false
            self.myScrollView.addSubview(odp3Text)
            
            //data zamówienia - label
            let dataLabel = UILabel(frame: CGRect(x: 10, y: 120, width: 70, height: 30))
            dataLabel.text = "L_DATA".localized() + ":"
            dataLabel.textColor = UIColor.darkGray
            dataLabel.font = UIFont.systemFont(ofSize: 14)
            dataLabel.textAlignment = .right
            self.myScrollView.addSubview(dataLabel)
            //data zamówienia - wartość
            let dataText = UILabel(frame: CGRect(x: 90, y: 120, width: Int(self.view.frame.size.width - 105), height: 30))
            dataText.text = zamowienie[0].za_data + " " + "L_NA_GODZ".localized() + " " + zamowienie[0].za_godz
            dataText.textColor = UIColor.darkGray
            dataText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(dataText)
            
            //ilość rezerwowanych miejsc - label
            let miejscLabel = UILabel(frame: CGRect(x: 10, y: 145, width: 70, height: 30))
            miejscLabel.text = "L_MIEJSC".localized() + ":"
            miejscLabel.textColor = UIColor.darkGray
            miejscLabel.font = UIFont.systemFont(ofSize: 14)
            miejscLabel.textAlignment = .right
            self.myScrollView.addSubview(miejscLabel)
            //ilość rezerwowanych miejsc - wartość
            let miejscText = UILabel(frame: CGRect(x: 90, y: 145, width: Int(self.view.frame.size.width - 105), height: 30))
            miejscText.text = zamowienie[0].za_miejsc
            miejscText.textColor = UIColor.darkGray
            miejscText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(miejscText)
            
            //czas pobytu - label
            let pobytLabel = UILabel(frame: CGRect(x: 10, y: 170, width: 70, height: 30))
            pobytLabel.text = "L_POBYT".localized() + ":"
            pobytLabel.textColor = UIColor.darkGray
            pobytLabel.font = UIFont.systemFont(ofSize: 14)
            pobytLabel.textAlignment = .right
            self.myScrollView.addSubview(pobytLabel)
            //czas pobytu  - wartość
            let pobytText = UILabel(frame: CGRect(x: 90, y: 170, width: Int(self.view.frame.size.width - 105), height: 30))
            pobytText.text = zamowienie[0].za_czas
            pobytText.textColor = UIColor.darkGray
            pobytText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(pobytText)
            
            //nazwisko zamówienia - label
            let nazwiskoLabel = UILabel(frame: CGRect(x: 10, y: 195, width: 70, height: 30))
            nazwiskoLabel.text = "L_NAZWISKO".localized() + ":"
            nazwiskoLabel.textColor = UIColor.darkGray
            nazwiskoLabel.font = UIFont.systemFont(ofSize: 14)
            nazwiskoLabel.textAlignment = .right
            self.myScrollView.addSubview(nazwiskoLabel)
            //data zamówienia - wartość
            let nazwiskoText = UILabel(frame: CGRect(x: 90, y: 195, width: Int(self.view.frame.size.width - 105), height: 30))
            nazwiskoText.text = zamowienie[0].za_imie + " " + zamowienie[0].za_nazwisko
            nazwiskoText.textColor = UIColor.darkGray
            nazwiskoText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(nazwiskoText)
            
            //telefon zamówienia - label
            let telefonLabel = UILabel(frame: CGRect(x: 10, y: 220, width: 70, height: 30))
            telefonLabel.text = "L_TELEFON".localized() + ":"
            telefonLabel.textColor = UIColor.darkGray
            telefonLabel.font = UIFont.systemFont(ofSize: 14)
            telefonLabel.textAlignment = .right
            self.myScrollView.addSubview(telefonLabel)
            //data zamówienia - wartość
            let telefonText = UILabel(frame: CGRect(x: 90, y: 220, width: Int(self.view.frame.size.width - 105), height: 30))
            telefonText.text = zamowienie[0].za_telefon
            telefonText.textColor = UIColor.darkGray
            telefonText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(telefonText)
            
            //email zamówienia - label
            let emailLabel = UILabel(frame: CGRect(x: 10, y: 245, width: 70, height: 30))
            emailLabel.text = "L_EMAIL".localized() + ":"
            emailLabel.textColor = UIColor.darkGray
            emailLabel.font = UIFont.systemFont(ofSize: 14)
            emailLabel.textAlignment = .right
            self.myScrollView.addSubview(emailLabel)
            //data zamówienia - wartość
            let emailText = UILabel(frame: CGRect(x: 90, y: 245, width: Int(self.view.frame.size.width - 105), height: 30))
            emailText.text = zamowienie[0].za_email
            emailText.textColor = UIColor.darkGray
            emailText.font = UIFont.systemFont(ofSize: 14)
            self.myScrollView.addSubview(emailText)
            
            //uwagi zamówienia - label
            let uwagiLabel = UILabel(frame: CGRect(x: 10, y: 270, width: 70, height: 45))
            uwagiLabel.text = "L_UWAGI".localized() + ":"
            uwagiLabel.textColor = UIColor.darkGray
            uwagiLabel.font = UIFont.systemFont(ofSize: 14)
            uwagiLabel.textAlignment = .right
            self.myScrollView.addSubview(uwagiLabel)
            //data zamówienia - wartość
            let uwagiText = UILabel(frame: CGRect(x: 90, y: 270, width: Int(self.view.frame.size.width - 105), height: 45))
            uwagiText.text = zamowienie[0].za_uwagi
            uwagiText.textColor = UIColor.darkGray
            uwagiText.font = UIFont.systemFont(ofSize: 14)
            uwagiText.numberOfLines = 2
            self.myScrollView.addSubview(uwagiText)
            
            //zamówione menu - podkład
            let pole1 = UIView(frame: CGRect(x: 10, y: 325, width: Int(self.view.frame.size.width - 20), height: 40))
            pole1.backgroundColor = UIColor.lightGray
            self.myScrollView.addSubview(pole1)
            //zamówione menu - text
            let menuLabel = UILabel(frame: CGRect(x: 20, y: 330, width: Int(self.view.frame.size.width - 40), height: 30))
            menuLabel.text = "L_ZAMOWIONE_MENU".localized()
            menuLabel.textColor = UIColor.darkGray
            menuLabel.font = UIFont.systemFont(ofSize: 16)
            self.myScrollView.addSubview(menuLabel)
            
            //jeżeli jest ustawiona opcja "mogę jeść"
            if zamowienie[0].za_moge != "0.00" {
                offset += 30
                //mogę jeść - label
                let mogeLabel = UILabel(frame: CGRect(x: 10, y: 375, width: 190, height: 30))
                mogeLabel.text = "L_MOGE_JESC_OD".localized() + ":"
                mogeLabel.textColor = UIColor.darkGray
                mogeLabel.font = UIFont.systemFont(ofSize: 14)
                mogeLabel.textAlignment = .right
                self.myScrollView.addSubview(mogeLabel)
                //data zamówienia - wartość
                let mogeText = UILabel(frame: CGRect(x: 210, y: 375, width: 100, height: 30))
                mogeText.text = zamowienie[0].za_moge
                mogeText.textColor = UIColor.darkGray
                mogeText.font = UIFont.systemFont(ofSize: 14)
                self.myScrollView.addSubview(mogeText)
            }
            
            //wyświetlenie zamówionych dań
            var i = 0
            if Shared.shared.zamowioneDania[0].zm_ile != "0"{ //jeżeli są dania do zamówienia
                for dan in Shared.shared.zamowioneDania{
                    let linia = UIView(frame: CGRect(x: 16, y: 380 + (30 * i) + offset, width: Int(self.view.frame.size.width - 32), height: 1))
                    linia.backgroundColor = UIColor.lightGray
                    self.myScrollView.addSubview(linia)
                    //ilość i nazwa dania
                    let danie = UILabel(frame: CGRect(x: 20, y: 380 + (30 * i) + offset, width: Int(self.view.frame.size.width - 120), height: 30))
                    danie.text = dan.zm_ile + " x " + dan.zm_nazwa
                    danie.textColor = UIColor.darkGray
                    danie.font = UIFont.systemFont(ofSize: 14)
                    //danie.lineBreakMode = .byWordWrapping
                    //danie.numberOfLines = 3
                    self.myScrollView.addSubview(danie)
                    //cena dania
                    let cena = UILabel(frame: CGRect(x: Int(self.view.frame.size.width - 116), y: 380 + (30 * i) + offset, width: 100, height: 30))
                    
                    //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
                    let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                    formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                    formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                    let numCena = formatter1.string(from: NSNumber(value: Float(dan.zm_cena)!))
                    
                    cena.text = numCena! + " " + "L_PLN".localized()
                    cena.textColor = UIColor.darkGray
                    cena.font = UIFont.systemFont(ofSize: 14)
                    cena.textAlignment = .right
                    self.myScrollView.addSubview(cena)
                    i += 1
                }
            
                let linia1 = UIView(frame: CGRect(x: 16, y: 380 + (30 * i) + offset, width: Int(self.view.frame.size.width - 32), height: 1))
                linia1.backgroundColor = UIColor.lightGray
                self.myScrollView.addSubview(linia1)
                //razem
                let cenaRazem = UILabel(frame: CGRect(x: 20, y: 380 + (30 * i) + offset, width: Int(self.view.frame.size.width - 120), height: 30))
                cenaRazem.text = "L_RAZEM".localized()
                cenaRazem.textColor = UIColor.darkGray
                cenaRazem.font = UIFont.boldSystemFont(ofSize: 14)
                self.myScrollView.addSubview(cenaRazem)
                //cena dania
                let cenaWartosc = UILabel(frame: CGRect(x: Int(self.view.frame.size.width - 116), y: 380 + (30 * i) + offset, width: 100, height: 30))
                
                //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
                let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                let numWartosc = formatter1.string(from: NSNumber(value: Float(zamowienie[0].cena_razem)!))
                
                cenaWartosc.text = numWartosc! + " " + "L_PLN".localized()
                cenaWartosc.textColor = UIColor.darkGray
                cenaWartosc.font = UIFont.boldSystemFont(ofSize: 14)
                cenaWartosc.textAlignment = .right
                self.myScrollView.addSubview(cenaWartosc)
                i += 1
                
                let linia2 = UIView(frame: CGRect(x: 16, y: 380 + (30 * i) + offset, width: Int(self.view.frame.size.width - 32), height: 1))
                linia2.backgroundColor = UIColor.lightGray
                self.myScrollView.addSubview(linia2)
            
            } else{ //jeżeli nie ma dań do zamówienia
                //brak - label
                let brakLabel = UILabel(frame: CGRect(x: 10, y: 368, width: 70, height: 30))
                brakLabel.text = "L_BRAK".localized()
                brakLabel.textColor = UIColor.darkGray
                brakLabel.font = UIFont.systemFont(ofSize: 14)
                brakLabel.textAlignment = .right
                self.myScrollView.addSubview(brakLabel)
                
            }
            
            if zamowienie[0].za_status_id == "0" || zamowienie[0].za_status_id == "1"{
                //przycisk "rezygnuję"
                let rezygnujeButton = UIButton.init(type: .system)
                rezygnujeButton.frame = CGRect(x: 10, y: 380 + (30 * i) + 20 + offset, width: Int(self.view.frame.size.width - 20), height: 40)
                rezygnujeButton.setTitle("L_REZYGNUJE_ZAM".localized(), for: .normal)
                rezygnujeButton.titleLabel?.textColor = UIColor.white
                rezygnujeButton.tintColor = UIColor.white
                rezygnujeButton.layer.cornerRadius = 5.0
                rezygnujeButton.backgroundColor = UIColor.gray
                rezygnujeButton.addTarget(self, action: #selector(buttonRezygnujeClic(_ :)), for: .touchUpInside)
                self.myScrollView.addSubview(rezygnujeButton)
                offset += 60  //wysokość przycisku
                
            }
            
            //ustalenie wysokośi myScrollView
            myScrollView.contentSize = CGSize(width: Int(self.view.frame.size.width), height: 380 + (30 * i) + 20 + offset)
            
        } //rezerwacja stolika
    
    
    }//viewDidLoad()

    @objc func buttonRezygnujeClic(_ : UIButton){
        
        //utworzenie Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        //myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        
        //send HTTP Request to Dostawa
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_rezygnacja.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = [
            "za_id": zamowienie[0].za_id,
            "za_uz_id": Shared.shared.uz_id,
            "za_re_id": location![0].e,
            "za_typ": zamowienie[0].za_typ,              //2 - zamówienie do stolika
            "za_email": zamowienie[0].za_email] as! [String: String]
      
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            displayMessage(userMessage: "L_BLAD_WYSLANIA_DANYCH".localized())
            return
        }

        
        let task = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in

            //self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "L_BLAD_WYSLANIE_REZYG".localized())
                print("error======\(String(describing: error))")
                return
            }
            
            //konwertowanie danych odebranych z serwera
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                print ("json:====== \(String(describing: json!))")
                //print ("json:==\(String(describing: json!["error_email"]!))")
                
                let success = String(describing: json!["success"])
                let zapis = String(describing: json!["zapis"])
                print("sses=\(success)")
                print("zapis=\(zapis)")
                
                
                if (success != "Optional(ok)"){ //jeżeli nie wyłano meila do restauracji
                    if (zapis != "Optional(ok)"){ //to jeżeli nie zapisano do bazy
                        self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                        self.displayMessage(userMessage: "L_BLAD_DANE_REZYG".localized())
                        return
                    }else{
                        self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                        self.displayMessage(userMessage: "L_BLAD_NIE_OK_REZYG".localized())
                        return
                    }
                }else{ //jeżeli wyłano poprawnie meil do restauracji
                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                    self.displayMessage(userMessage: "L_REZYGNACJA_OK".localized())
                }
            } catch{
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "L_BLAD_REZYG".localized())
                print(error)
            }
        }
        
        task.resume()
        
        //_ = navigationController?.popViewController(animated: true)//powrót do poprzedniego view
    }
    
    //komunikaty z wysyłki zamówienia
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "L_KOMUNIKAT".localized(), message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                
                DispatchQueue.main.async {
                   
                    //pobranie zamówień [Zamowienie]
                    self.downloadJSON_zamowienia{
                        //i zapisanie ich do pamięci podręcznej
                        Shared.shared.zamowienia = self.zamZam
                    
                        _ = self.navigationController?.popViewController(animated: true)//powrót do poprzedniego view
                   
                    }
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator.removeFromSuperview()
        }
    }
    
    //=========================================================
    //funkcja pobierająca JSONa z zamówieniami
    //=========================================================
    func downloadJSON_zamowienia(completed: @escaping () -> ()) {
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_zamowienia&uz_id=\(Shared.shared.uz_id!)&re=\(location![0].e)&lang=\(Localize.currentLanguage())")
        //print(url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    //print(data)
                    self.zamZam = try JSONDecoder().decode([Zamowienie].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    Shared.shared.zamowienia = nil
                    print ("JSON Error")
                }
            }
        }.resume()
    }
    
    
}
