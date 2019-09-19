//
//  StolikViewController.swift
//  Pager
//
//  Created by darys on 01.06.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Localize_Swift

class StolikViewController: UIViewController {

    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var danieNS = [DanieNaStole]()  //tablica dań na stoliku
    var razemNS = [DaniaRazem]()  //razem na stoliku
    var zamZam = [Zamowienie]()  //tablica zamówień
    var strefy_dostawy = [Strefa]() //lista stref dostawy wybranej restauracji
    var activityIndicator = UIActivityIndicatorView() //wskaźnik aktywności
    var iloscZamowien: Int?
    
    @IBOutlet weak var stolikView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "L_STOLIK".localized()
        self.stolikView.backgroundColor = UIColor.lightGray
        
        let rightBarButton = UIBarButtonItem(title: "L_WYCZYSC".localized(), style: UIBarButtonItemStyle.plain, target: self, action: #selector(myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
       
        
        
        
        //----- wskaźnik aktywności-----------
        activityIndicator.center = CGPoint.init(x: self.view.frame.size.width/2, y: 200)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        self.activityIndicator.stopAnimating()
        
        var i:Int = 0
        let j = Shared.shared.stolik.count //lista dań na stoliku - ilość
        
        //ustawienie odpowiedniej długości przewijanej ramki (ekranu)
         print(((105 * j) + 305))
        print(">")
        print(self.view.frame.height)
        if CGFloat((105 * j) + 305) > (self.view.frame.height) {
            self.stolikView.frame.size.height = CGFloat((105 * j) + 305 + 50) //+50 bo źle wyświetla fiszki z ostatnim daniem na liście na granicy działania tego if'a
           // print("większe")
            //print(self.stolikView.frame.size.height)
        }else{
            self.stolikView.frame.size.height = self.view.frame.height
            //print("mniejsze")
           // print(self.stolikView.frame.size.height)
       }
        
        //jeżeli w pierwszym elemencie tablicy dań na stoliku st_ile = "0" tzn. że nie ma dań
        if Shared.shared.stolik[0].st_ile != "0" { //wyświetlaj dania jeżeli są
            //wyświetlwnie dań stolika
            for dan in Shared.shared.stolik{
                if let danie = Bundle.main.loadNibNamed("danie", owner: self, options: nil)![0] as? DanieViewController {

                    danie.tag = i
                    danie.plusButton.tag = i
                    danie.minusButton.tag = i
                    danie.nazwaLabel.text = "\(dan.da_nazwa)"
                    danie.opisLabel.text = "\(dan.da_opis)"
                    danie.ileLabel.text = "\(dan.st_ile)"
                    
                    let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                    formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                    formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                    let cena = Float(dan.st_cena)!
                    let numCena = formatter1.string(from: NSNumber(value: cena))
                    
                    danie.cenaLabel.text = numCena! + " " + "L_PLN".localized()
                    danie.wagaLabel.text = "\(dan.st_waga) " + "L_G".localized()
                    danie.kcalLabel.text = "\(dan.st_kcal) " + "L_KCAL".localized()
                    danie.plusButton.addTarget(self, action: #selector(StolikViewController.pressedButtonPlus(sender:)), for: .touchUpInside)
                    danie.minusButton.addTarget(self, action: #selector(StolikViewController.pressedButtonMinus(sender:)), for: .touchUpInside)
                    danie.frame = CGRect(x: 5, y: (105 * i) + 5,
                                         width: Int(self.stolikView.frame.width - 10), height: 100)

                    //bo sie zle wyświetla jak większa ilość dań - nie rozszerza się ekran
                    if CGFloat((105 * (i + 1)) + 305) > (self.view.frame.height){
                        print("włączony flexibleHeight")
                        danie.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    }
                    //danie.frame.origin.y = CGFloat((110 * i) + 70)
                    //danie.frame.origin.x = 5

                    self.stolikView.addSubview(danie)
                    i += 1
                }
                
                
            }//jeżeli są dania na stoliku
            
            //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
            let formatter1 = NumberFormatter() //deklaracja obiektu formatera
            formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
            formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
            
            //pobranie RAZEM na stoliku [razemNS]
            self.downloadJSON_stolik_razem{
                if let razem = Bundle.main.loadNibNamed("razem", owner: self, options: nil)![0] as? RazemView{
                    razem.razemLabel.text = "L_RAZEM".localized()
                    
                    let cenaRazem = Float(self.razemNS[0].cena_s)!
                    let numCena = formatter1.string(from: NSNumber(value: cenaRazem))
                    razem.cenaRazem.text = "\(numCena! ) " + "L_PLN".localized()
                    
                    razem.wagaRazem.text = "\(self.razemNS[0].waga_s) " + "L_G".localized()
                    razem.kcalRazem.text = "\(self.razemNS[0].kcal_s) " + "L_KCAL".localized()
                    razem.frame = CGRect(x: 5, y: (105 * i) + 5,
                                         width: Int(self.stolikView.frame.width - 10), height: 33)
                    self.stolikView.addSubview(razem)
                    //zapamietanie ceny razem dla "dostawy" i "do stolika"
                    Shared.shared.cenaRazem = self.razemNS[0].cena_s
                    Shared.shared.kosztOpakowan = self.razemNS[0].koszt_opakowan
                    //print(Shared.shared.cenaRazem!)
                }
            }
        
        
        
        }
        
        //----------------------------------------------
        //sekcja przycisków
        //----------------------------------------------
        //pobranie danych wybranej restauracji
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        
        if location![0].e != "0" {  //jeżeli jest id restauracji
            //pobranie danych restauracji
            let restauracja = StephencelisDB.instance.getRestaurantWithId(res: location![0].e)
            
            //komunikat o opakowaniach - label
            var op:Int = 0
            if  (restauracja[0].opak != "0.00"){
                op += 50
                //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
                let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                
                //formatowanie ceny opakowania
                let cenaOpak = Float(restauracja[0].opak)!
                let numOpak = formatter1.string(from: NSNumber(value: cenaOpak))
                //razem.cenaRazem.text = "\(numOpak! ) " + "L_PLN".localized()
                
                let opakowaniaLabel = UILabel(frame: CGRect(x: 10, y: (105 * i) + op, width: Int(self.view.frame.size.width - 20), height: 45))
                opakowaniaLabel.text = "* " + "L_DOLICZANIE_OPAKOWANIA".localized() + " " + numOpak! + " " + "L_PLN".localized()
                opakowaniaLabel.textColor = UIColor.darkGray
                opakowaniaLabel.font = UIFont.systemFont(ofSize: 14)
                opakowaniaLabel.numberOfLines = 2
                self.stolikView.addSubview(opakowaniaLabel)
            }
            
            //przycisk "dostawa"
            let dostawaButton = UIButton.init(type: .system)
            dostawaButton.frame = CGRect(x: 10, y: (105 * i) + 50 + op, width: Int(self.view.frame.size.width - 20), height: 40)
            dostawaButton.setTitle("L_ZAM_DOSTAWA".localized(), for: .normal)
            dostawaButton.titleLabel?.textColor = UIColor.white
            dostawaButton.tintColor = UIColor.white
            dostawaButton.layer.cornerRadius = 5.0
            if  (restauracja[0].dos == "1")&&(Shared.shared.stolik[0].st_ile != "0") {  //przycisk aktywny
                dostawaButton.backgroundColor = Shared.shared.malinaColor
                dostawaButton.addTarget(self, action: #selector(buttonDostawaClic(_ :)), for: .touchUpInside)
            }else{                          //przycisk nieaktywny
                dostawaButton.backgroundColor = Shared.shared.malinaColorLight
            }
            self.stolikView.addSubview(dostawaButton)
            
            //przycisk "do stolika"
            let do_stolikaButton = UIButton.init(type: .system)
            do_stolikaButton.frame = CGRect(x: 10, y: (105 * i) + 100 + op, width: Int(self.view.frame.size.width - 20), height: 40)
            do_stolikaButton.setTitle("L_ZAM_DO_STOLIKA".localized(), for: .normal)
            do_stolikaButton.titleLabel?.textColor = UIColor.white
            do_stolikaButton.tintColor = UIColor.white
            do_stolikaButton.layer.cornerRadius = 5.0
            if  (restauracja[0].do_st == "1")&&(Shared.shared.stolik[0].st_ile != "0") {  //przycisk aktywny
                do_stolikaButton.backgroundColor = Shared.shared.malinaColor
                do_stolikaButton.addTarget(self, action: #selector(buttonDoStolikaClic(_ :)), for: .touchUpInside)
            }else{                          //przycisk nieaktywny
                do_stolikaButton.backgroundColor = Shared.shared.malinaColorLight
            }
            self.stolikView.addSubview(do_stolikaButton)
            
            //przycisk "rezerwacja stolików"
            let rezerwacjaButton = UIButton.init(type: .system)
            rezerwacjaButton.frame = CGRect(x: 10, y: (105 * i) + 150 + op, width: Int(self.view.frame.size.width - 20), height: 40)
            rezerwacjaButton.setTitle("L_ZAM_REZERWACJA".localized(), for: .normal)
            rezerwacjaButton.titleLabel?.textColor = UIColor.white
            rezerwacjaButton.tintColor = UIColor.white
            rezerwacjaButton.layer.cornerRadius = 5.0
            if  restauracja[0].rez == "1" {  //przycisk aktywny
                rezerwacjaButton.backgroundColor = Shared.shared.malinaColor
                rezerwacjaButton.addTarget(self, action: #selector(buttonRezerwacjaClic(_ :)), for: .touchUpInside)
            }else{                          //przycisk nieaktywny
                rezerwacjaButton.backgroundColor = Shared.shared.malinaColorLight
            }
            self.stolikView.addSubview(rezerwacjaButton)
            
            //przycisk "zamówienia"
             if  Shared.shared.zamowienia[0].za_id != "0"{
                iloscZamowien =  Shared.shared.zamowienia.count
             }else{
                 iloscZamowien = 0
            }
            let zamowieniaButton = UIButton.init(type: .system)
            zamowieniaButton.frame = CGRect(x: 10, y: (105 * i) + 200 + op, width: Int(self.view.frame.size.width - 20), height: 40)
            zamowieniaButton.setTitle("L_ZAMOWIENIA".localized() + " (" + "\(String(describing: iloscZamowien!))" + ")", for: .normal)
            zamowieniaButton.titleLabel?.textColor = UIColor.white
            zamowieniaButton.tintColor = UIColor.white
            zamowieniaButton.layer.cornerRadius = 5.0
            if  Shared.shared.zamowienia[0].za_id != "0"{  //przycisk aktywny
                zamowieniaButton.backgroundColor = Shared.shared.malinaColor
                zamowieniaButton.addTarget(self, action: #selector(buttonZamowieniaClic(_ :)), for: .touchUpInside)
            }else{                          //przycisk nieaktywny
                zamowieniaButton.backgroundColor = Shared.shared.malinaColorLight
            }
            self.stolikView.addSubview(zamowieniaButton)
            
        }
            //print(self.stolikView.frame.height)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.iloscZamowien =  Shared.shared.zamowienia.count
        //trzeba zaktualizować ilość zamówień na przycisku zamówienia jak dodawane jest kolejne zamówienie !!!
        //print("odddddddd=\(String(describing: iloscZamowien))")
    }
    
    //----------------------------------------
    //przycisk Dostawa
    //----------------------------------------
    @objc func buttonDostawaClic(_ : UIButton){
        
        //pobranie stref dostawy
        self.downloadJSON_strefy{
            //i zapisanie ich do pamięci podręcznej
            Shared.shared.strefy = self.strefy_dostawy
            //Shared.shared.strefa = 0 //domyślne ustawienie strefy dostawy w AppDelegate
            
            if(Shared.shared.strefy[0].czynne == "1"){ //jeżeli czas składania zamówienia właściwy (od-do)
                let razem = Float(Shared.shared.cenaRazem.replacingOccurrences(of: ",", with: "."))
                if((razem!) > (Float(Shared.shared.strefy[0].str_wart_min))!){//jeżeli kwota powyżej minimum
                    
                    
                    self.performSegue(withIdentifier: "sbDostawa", sender: self) //przejście do DostawaVC
                }else{
                    self.displayAlertKwota()
                }
            }else{
                self.displayAlertNieczynne()
            }
        }
    }
    
    
    @objc func buttonDoStolikaClic(_ : UIButton){
        performSegue(withIdentifier: "sbDoStolika", sender: self) //przejście do DoStolikaVC
    }
    
    @objc func buttonRezerwacjaClic(_ : UIButton){
        performSegue(withIdentifier: "sbRezerwacja", sender: self) //przejście do RezerwacjaVC
    }
    
    @objc func buttonZamowieniaClic(_ : UIButton){
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        if location![0].e != "0" {
            if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){
                //pobranie zamówień [Zamowienie] - przeniesione do Menu
               // self.downloadJSON_zamowienia{
                    //i zapisanie ich do pamięci podręcznej
                   // Shared.shared.zamowienia = self.zamZam
                    
                    //przejście do ZamowieniaTableVC
                    self.performSegue(withIdentifier: "sbZamowienia", sender: self)
              //  }
            }
        }else{
            displayAlertResta()
        }
    }
    
    //--------------------------------------------
    //przycisk "Wyczyść"
    //--------------------------------------------
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        print("myRightSideBarButtonItemTapped")
        //print(sender.tag)
        let res = kasujStolik() //usuwanie wszystkich dań ze stolika
        
        
        //----- wskaźnik aktywności-----------
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        //-------------------------------------
        
        //opóźnienie żeby zdążyło przeładować dane
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
            
            if res == 1 {
                //usunięcie wyświetlania wszystkich dań ze stolika
                for subView in self.stolikView.subviews {
                    subView.removeFromSuperview()
                }
                
                
                //pobranie dań na stoliku [danieNS]
                self.downloadJSON_stolik{
                    //i zapisanie ich do pamięci podręcznej
                    Shared.shared.stolik = self.danieNS
                    
                    //żeby nie wyświetlał pustego dania
                    if Shared.shared.stolik[0].st_ile != "0" { //wyświetlaj dania jeżeli są
                        
                        var i:Int = 0
                        let j = self.danieNS.count
                        
                        //ustawienie odpowiedniej długości przewijanej ramki (ekranu)
                        if CGFloat((105 * j) + 305) > (self.view.frame.height) {
                            self.stolikView.frame.size.height = CGFloat((105 * j) + 305)
                        }else{
                            self.stolikView.frame.size.height = self.view.frame.height
                        }
                        
                        for dan in self.danieNS{
                            if let danie = Bundle.main.loadNibNamed("danie", owner: self, options: nil)![0] as? DanieViewController {
                                danie.tag = i
                                danie.plusButton.tag = i
                                danie.minusButton.tag = i
                                danie.nazwaLabel.text = "\(dan.da_nazwa)"
                                danie.opisLabel.text = "\(dan.da_opis)"
                                danie.ileLabel.text = "\(dan.st_ile)"
                                danie.cenaLabel.text = "\(dan.st_cena) " + "L_PLN".localized()
                                danie.wagaLabel.text = "\(dan.st_waga) " + "L_G".localized()
                                danie.kcalLabel.text = "\(dan.st_kcal) " + "L_KCAL".localized()
                                danie.plusButton.addTarget(self, action: #selector(StolikViewController.pressedButtonPlus(sender:)), for: .touchUpInside)
                                danie.minusButton.addTarget(self, action: #selector(StolikViewController.pressedButtonMinus(sender:)), for: .touchUpInside)
                                danie.frame = CGRect(x: 5, y: (105 * i) + 5,
                                                     width: Int(self.stolikView.frame.width - 10), height: 100)
                                
                                //bo sie zle wyświetla jak większa iość dań - nie rozszerza się ekran
                                if CGFloat((105 * (i + 1)) + 305) > (self.view.frame.height){
                                    //print("włączony flexibleHeight")
                                    danie.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                                }
                                
                                self.stolikView.addSubview(danie)
                                i += 1
                                
                                
                            }
                            
                            //pobranie RAZEM na stoliku [razemNS]
                            self.downloadJSON_stolik_razem{
                                if let razem = Bundle.main.loadNibNamed("razem", owner: self, options: nil)![0] as? RazemView{
                                    razem.razemLabel.text = "L_RAZEM".localized()
                                    razem.cenaRazem.text = "\(self.razemNS[0].cena_s) " + "L_PLN".localized()
                                    razem.wagaRazem.text = "\(self.razemNS[0].waga_s) " + "L_G".localized()
                                    razem.kcalRazem.text = "\(self.razemNS[0].kcal_s) " + "L_KCAL".localized()
                                    razem.frame = CGRect(x: 5, y: (105 * i) + 5,
                                                         width: Int(self.stolikView.frame.width - 10), height: 33)
                                    self.stolikView.addSubview(razem)
                                    //zapamietanie ceny razem dla "dostawy" i "do stolika"
                                    Shared.shared.cenaRazem = self.razemNS[0].cena_s
                                    Shared.shared.kosztOpakowan = self.razemNS[0].koszt_opakowan
                                }
                            }
                        }
                        
                    }
                    
                    //----------------------------------------------
                    //sekcja przycisków
                    //----------------------------------------------
                    //pobranie danych wybranej restauracji
                    self.location = StephencelisDB.instance.getMemory(memo: "mem_lok")
                    var j = self.danieNS.count
                    if Shared.shared.stolik[0].st_ile == "0"{
                        j = 0
                    }
                    
                    if self.location![0].e != "0" {  //jeżeli jest id restauracji
                        //pobranie danych restauracji
                        let restauracja = StephencelisDB.instance.getRestaurantWithId(res: self.location![0].e)
                        
                        //przycisk "dostawa"
                        let dostawaButton = UIButton.init(type: .system)
                        dostawaButton.frame = CGRect(x: 10, y: (105 * j) + 50, width: Int(self.view.frame.size.width - 20), height: 40)
                        dostawaButton.setTitle("L_ZAM_DOSTAWA".localized(), for: .normal)
                        dostawaButton.titleLabel?.textColor = UIColor.white
                        dostawaButton.tintColor = UIColor.white
                        dostawaButton.layer.cornerRadius = 5.0
                        if  (restauracja[0].dos == "1")&&(Shared.shared.stolik[0].st_ile != "0") {  //przycisk aktywny
                            dostawaButton.backgroundColor = Shared.shared.malinaColor
                            dostawaButton.addTarget(self, action: #selector(self.buttonDostawaClic(_ :)), for: .touchUpInside)
                        }else{                          //przycisk nieaktywny
                            dostawaButton.backgroundColor = Shared.shared.malinaColorLight
                        }
                        self.stolikView.addSubview(dostawaButton)
                        
                        //przycisk "do stolika"
                        let do_stolikaButton = UIButton.init(type: .system)
                        do_stolikaButton.frame = CGRect(x: 10, y: (105 * j) + 100, width: Int(self.view.frame.size.width - 20), height: 40)
                        do_stolikaButton.setTitle("L_ZAM_DO_STOLIKA".localized(), for: .normal)
                        do_stolikaButton.titleLabel?.textColor = UIColor.white
                        do_stolikaButton.tintColor = UIColor.white
                        do_stolikaButton.layer.cornerRadius = 5.0
                        if  (restauracja[0].do_st == "1")&&(Shared.shared.stolik[0].st_ile != "0") {  //przycisk aktywny
                            do_stolikaButton.backgroundColor = Shared.shared.malinaColor
                            do_stolikaButton.addTarget(self, action: #selector(self.self.buttonDoStolikaClic(_ :)), for: .touchUpInside)
                        }else{                          //przycisk nieaktywny
                            do_stolikaButton.backgroundColor = Shared.shared.malinaColorLight
                        }
                        self.stolikView.addSubview(do_stolikaButton)
                        
                        //przycisk "rezerwacja stolików"
                        let rezerwacjaButton = UIButton.init(type: .system)
                        rezerwacjaButton.frame = CGRect(x: 10, y: (105 * j) + 150, width: Int(self.view.frame.size.width - 20), height: 40)
                        rezerwacjaButton.setTitle("L_ZAM_REZERWACJA".localized(), for: .normal)
                        rezerwacjaButton.titleLabel?.textColor = UIColor.white
                        rezerwacjaButton.tintColor = UIColor.white
                        rezerwacjaButton.layer.cornerRadius = 5.0
                        if  restauracja[0].rez == "1" {  //przycisk aktywny
                            rezerwacjaButton.backgroundColor = Shared.shared.malinaColor
                            rezerwacjaButton.addTarget(self, action: #selector(self.self.buttonRezerwacjaClic(_ :)), for: .touchUpInside)
                        }else{                          //przycisk nieaktywny
                            rezerwacjaButton.backgroundColor = Shared.shared.malinaColorLight
                        }
                        self.stolikView.addSubview(rezerwacjaButton)
                        
                        //przycisk "zamówienia"
                        if  Shared.shared.zamowienia[0].za_id != "0"{
                            self.iloscZamowien =  Shared.shared.zamowienia.count
                        }else{
                            self.iloscZamowien = 0
                        }
                        let zamowieniaButton = UIButton.init(type: .system)
                        zamowieniaButton.frame = CGRect(x: 10, y: (105 * j) + 200, width: Int(self.view.frame.size.width - 20), height: 40)
                        zamowieniaButton.setTitle("L_ZAMOWIENIA".localized() + " (" + "\(String(describing: self.iloscZamowien!))" + ")", for: .normal)
                        zamowieniaButton.titleLabel?.textColor = UIColor.white
                        zamowieniaButton.tintColor = UIColor.white
                        zamowieniaButton.layer.cornerRadius = 5.0
                        if  Shared.shared.zamowienia[0].za_id != "0"{  //przycisk aktywny
                            zamowieniaButton.backgroundColor = Shared.shared.malinaColor
                            zamowieniaButton.addTarget(self, action: #selector(self.buttonZamowieniaClic(_ :)), for: .touchUpInside)
                        }else{                          //przycisk nieaktywny
                            zamowieniaButton.backgroundColor = Shared.shared.malinaColorLight
                        }
                        self.stolikView.addSubview(zamowieniaButton)
                        
                    }
                    
                }
                
                
            }
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        
    }
    
    
    //-------------------------------------------
    //przycisk +
    //-------------------------------------------
    @objc func pressedButtonPlus(sender:UIButton){
       //print(sender.tag)
        let res = aktualizujStolik(akcja: "1",indeks: sender.tag) //inkrementacja dania
        
        //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
        
        //----- wskaźnik aktywności-----------
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        //-------------------------------------
        
        //opóźnienie żeby zdążyło przeładować dane
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
        
        if res == 1 {
            //usunięcie wyświetlania wszystkich dań ze stolika
            for subView in self.stolikView.subviews {
                subView.removeFromSuperview()
            }
         
            
            //pobranie dań na stoliku [danieNS]
            self.downloadJSON_stolik{
                //i zapisanie ich do pamięci podręcznej
                Shared.shared.stolik = self.danieNS
                
                var i:Int = 0
                let j = self.danieNS.count
                
                //ustawienie odpowiedniej długości przewijanej ramki (ekranu)
                if CGFloat((105 * j) + 305) > (self.view.frame.height) {
                    self.stolikView.frame.size.height = CGFloat((105 * j) + 305 + 50)//+50 j.w.
                }else{
                    self.stolikView.frame.size.height = self.view.frame.height
                }
                
                for dan in self.danieNS{
                    if let danie = Bundle.main.loadNibNamed("danie", owner: self, options: nil)![0] as? DanieViewController {
                        danie.tag = i
                        danie.plusButton.tag = i
                        danie.minusButton.tag = i
                        danie.nazwaLabel.text = "\(dan.da_nazwa)"
                        danie.opisLabel.text = "\(dan.da_opis)"
                        danie.ileLabel.text = "\(dan.st_ile)"
                        
                        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                        let cena = Float(dan.st_cena)!
                        let numCena = formatter1.string(from: NSNumber(value: cena))
                        
                        danie.cenaLabel.text = numCena! + " " + "L_PLN".localized()
                        danie.wagaLabel.text = "\(dan.st_waga) " + "L_G".localized()
                        danie.kcalLabel.text = "\(dan.st_kcal) " + "L_KCAL".localized()
                        danie.plusButton.addTarget(self, action: #selector(StolikViewController.pressedButtonPlus(sender:)), for: .touchUpInside)
                        danie.minusButton.addTarget(self, action: #selector(StolikViewController.pressedButtonMinus(sender:)), for: .touchUpInside)
                        danie.frame = CGRect(x: 5, y: (105 * i) + 5,
                                             width: Int(self.stolikView.frame.width - 10), height: 100)
                        
                        //bo sie zle wyświetla jak większa iość dań - nie rozszerza się ekran
                        if CGFloat((105 * (i + 1)) + 305) > (self.view.frame.height){
                            //print("włączony flexibleHeight")
                            danie.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        }
                      
                        self.stolikView.addSubview(danie)
                        i += 1
                        
                        
                    }
                    
                    //pobranie RAZEM na stoliku [razemNS]
                    self.downloadJSON_stolik_razem{
                        if let razem = Bundle.main.loadNibNamed("razem", owner: self, options: nil)![0] as? RazemView{
                            razem.razemLabel.text = "L_RAZEM".localized()
                            
                            let cenaRazem = Float(self.razemNS[0].cena_s)!
                            let numCena = formatter1.string(from: NSNumber(value: cenaRazem))
                            razem.cenaRazem.text = "\(numCena! ) " + "L_PLN".localized()
                        
                            razem.wagaRazem.text = "\(self.razemNS[0].waga_s) " + "L_G".localized()
                            razem.kcalRazem.text = "\(self.razemNS[0].kcal_s) " + "L_KCAL".localized()
                            razem.frame = CGRect(x: 5, y: (105 * i) + 5,
                                                 width: Int(self.stolikView.frame.width - 10), height: 33)
                            self.stolikView.addSubview(razem)
                            //zapamietanie ceny razem dla "dostawy" i "do stolika"
                            Shared.shared.cenaRazem = self.razemNS[0].cena_s
                            Shared.shared.kosztOpakowan = self.razemNS[0].koszt_opakowan
                        }
                    }
                    
                }
                
                //----------------------------------------------
                //sekcja przycisków
                //----------------------------------------------
                //pobranie danych wybranej restauracji
                self.location = StephencelisDB.instance.getMemory(memo: "mem_lok")
               
                
                if self.location![0].e != "0" {  //jeżeli jest id restauracji
                    //pobranie danych restauracji
                    let restauracja = StephencelisDB.instance.getRestaurantWithId(res: self.location![0].e)
                    
                    //komunikat o opakowaniach - label
                    var op:Int = 0
                    if  (restauracja[0].opak != "0.00"){
                        op += 50
                        //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
                        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                        
                        //formatowanie ceny opakowania
                        let cenaOpak = Float(restauracja[0].opak)!
                        let numOpak = formatter1.string(from: NSNumber(value: cenaOpak))
                        //razem.cenaRazem.text = "\(numOpak! ) " + "L_PLN".localized()
                        
                        let opakowaniaLabel = UILabel(frame: CGRect(x: 10, y: (105 * j) + op, width: Int(self.view.frame.size.width - 20), height: 45))
                        opakowaniaLabel.text = "* " + "L_DOLICZANIE_OPAKOWANIA".localized() + " " + numOpak! + " " + "L_PLN".localized()
                        opakowaniaLabel.textColor = UIColor.darkGray
                        opakowaniaLabel.font = UIFont.systemFont(ofSize: 14)
                        opakowaniaLabel.numberOfLines = 2
                        self.stolikView.addSubview(opakowaniaLabel)
                    }
                    
                    
                    //przycisk "dostawa"
                    let dostawaButton = UIButton.init(type: .system)
                    dostawaButton.frame = CGRect(x: 10, y: (105 * j) + 50 + op , width: Int(self.view.frame.size.width - 20), height: 40)
                    dostawaButton.setTitle("L_ZAM_DOSTAWA".localized(), for: .normal)
                    dostawaButton.titleLabel?.textColor = UIColor.white
                    dostawaButton.tintColor = UIColor.white
                    dostawaButton.layer.cornerRadius = 5.0
                    if  (restauracja[0].dos == "1")&&(Shared.shared.stolik[0].st_ile != "0") {  //przycisk aktywny
                        dostawaButton.backgroundColor = Shared.shared.malinaColor
                        dostawaButton.addTarget(self, action: #selector(self.buttonDostawaClic(_ :)), for: .touchUpInside)
                    }else{                          //przycisk nieaktywny
                        dostawaButton.backgroundColor = Shared.shared.malinaColorLight
                    }
                    self.stolikView.addSubview(dostawaButton)
                    
                    //przycisk "do stolika"
                    let do_stolikaButton = UIButton.init(type: .system)
                    do_stolikaButton.frame = CGRect(x: 10, y: (105 * j) + 100 + op, width: Int(self.view.frame.size.width - 20), height: 40)
                    do_stolikaButton.setTitle("L_ZAM_DO_STOLIKA".localized(), for: .normal)
                    do_stolikaButton.titleLabel?.textColor = UIColor.white
                    do_stolikaButton.tintColor = UIColor.white
                    do_stolikaButton.layer.cornerRadius = 5.0
                    if  (restauracja[0].do_st == "1")&&(Shared.shared.stolik[0].st_ile != "0") {  //przycisk aktywny
                        do_stolikaButton.backgroundColor = Shared.shared.malinaColor
                        do_stolikaButton.addTarget(self, action: #selector(self.buttonDoStolikaClic(_ :)), for: .touchUpInside)
                    }else{                          //przycisk nieaktywny
                        do_stolikaButton.backgroundColor = Shared.shared.malinaColorLight
                    }
                    self.stolikView.addSubview(do_stolikaButton)
                    
                    //przycisk "rezerwacja stolików"
                    let rezerwacjaButton = UIButton.init(type: .system)
                    rezerwacjaButton.frame = CGRect(x: 10, y: (105 * j) + 150 + op, width: Int(self.view.frame.size.width - 20), height: 40)
                    rezerwacjaButton.setTitle("L_ZAM_REZERWACJA".localized(), for: .normal)
                    rezerwacjaButton.titleLabel?.textColor = UIColor.white
                    rezerwacjaButton.tintColor = UIColor.white
                    rezerwacjaButton.layer.cornerRadius = 5.0
                    if  restauracja[0].rez == "1" {  //przycisk aktywny
                        rezerwacjaButton.backgroundColor = Shared.shared.malinaColor
                        rezerwacjaButton.addTarget(self, action: #selector(self.buttonRezerwacjaClic(_ :)), for: .touchUpInside)
                    }else{                          //przycisk nieaktywny
                        rezerwacjaButton.backgroundColor = Shared.shared.malinaColorLight
                    }
                    self.stolikView.addSubview(rezerwacjaButton)
                    
                    //przycisk "zamówienia"
                    if  Shared.shared.zamowienia[0].za_id != "0"{
                        self.iloscZamowien =  Shared.shared.zamowienia.count
                    }else{
                        self.iloscZamowien = 0
                    }
                    let zamowieniaButton = UIButton.init(type: .system)
                    zamowieniaButton.frame = CGRect(x: 10, y: (105 * j) + 200 + op, width: Int(self.view.frame.size.width - 20), height: 40)
                    zamowieniaButton.setTitle("L_ZAMOWIENIA".localized() + " (" + "\(String(describing: self.iloscZamowien!))" + ")", for: .normal)
                    zamowieniaButton.titleLabel?.textColor = UIColor.white
                    zamowieniaButton.tintColor = UIColor.white
                    zamowieniaButton.layer.cornerRadius = 5.0
                    if  Shared.shared.zamowienia[0].za_id != "0"{  //przycisk aktywny
                        zamowieniaButton.backgroundColor = Shared.shared.malinaColor
                        zamowieniaButton.addTarget(self, action: #selector(self.buttonZamowieniaClic(_ :)), for: .touchUpInside)
                    }else{                          //przycisk nieaktywny
                        zamowieniaButton.backgroundColor = Shared.shared.malinaColorLight
                    }
                    self.stolikView.addSubview(zamowieniaButton)
                    
                }
            }
            
            
        }
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
    }
    
    //-----------------------------------------------
    //przycisk -
    //-----------------------------------------------
    @objc func pressedButtonMinus(sender:UIButton){
       
        //print(sender.tag)
        let res = aktualizujStolik(akcja: "2",indeks: sender.tag) //dekrementacja dania
        
        //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
        
        //----- wskaźnik aktywności-----------
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        //-------------------------------------
        
        //opóźnienie żeby zdążyło przeładować dane
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
        
        if res == 1 {
            //usunięcie wyświetlania wszystkich dań ze stolika
            for subView in self.stolikView.subviews {
                subView.removeFromSuperview()
            }
         
            
            //pobranie dań na stoliku [danieNS]
            self.downloadJSON_stolik{
                //i zapisanie ich do pamięci podręcznej
                Shared.shared.stolik = self.danieNS
              
                //żeby nie wyświetlał pustego dania 
               if Shared.shared.stolik[0].st_ile != "0" { //wyświetlaj dania jeżeli są
                
                var i:Int = 0
                let j = self.danieNS.count
                
                    //ustawienie odpowiedniej długości przewijanej ramki (ekranu)
                    if CGFloat((105 * j) + 305) > (self.view.frame.height) {
                        self.stolikView.frame.size.height = CGFloat((105 * j) + 305 + 50)//+50 j.w.
                    }else{
                        self.stolikView.frame.size.height = self.view.frame.height
                    }
                
                    for dan in self.danieNS{
                        if let danie = Bundle.main.loadNibNamed("danie", owner: self, options: nil)![0] as? DanieViewController {
                            danie.tag = i
                            danie.plusButton.tag = i
                            danie.minusButton.tag = i
                            danie.nazwaLabel.text = "\(dan.da_nazwa)"
                            danie.opisLabel.text = "\(dan.da_opis)"
                            danie.ileLabel.text = "\(dan.st_ile)"
                            
                            let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                            formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                            formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                            let cena = Float(dan.st_cena)!
                            let numCena = formatter1.string(from: NSNumber(value: cena))
                            
                            danie.cenaLabel.text = numCena! + " " + "L_PLN".localized()
                            danie.wagaLabel.text = "\(dan.st_waga) " + "L_G".localized()
                            danie.kcalLabel.text = "\(dan.st_kcal) " + "L_KCAL".localized()
                            danie.plusButton.addTarget(self, action: #selector(StolikViewController.pressedButtonPlus(sender:)), for: .touchUpInside)
                            danie.minusButton.addTarget(self, action: #selector(StolikViewController.pressedButtonMinus(sender:)), for: .touchUpInside)
                            danie.frame = CGRect(x: 5, y: (105 * i) + 5,
                                                 width: Int(self.stolikView.frame.width - 10), height: 100)
                            
                            //bo sie zle wyświetla jak większa iość dań - nie rozszerza się ekran
                            if CGFloat((105 * (i + 1)) + 305) > (self.view.frame.height){
                                //print("włączony flexibleHeight")
                                danie.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                            }
                        
                            self.stolikView.addSubview(danie)
                            i += 1
                            
                            
                        }

                        //pobranie RAZEM na stoliku [razemNS]
                        self.downloadJSON_stolik_razem{
                            if let razem = Bundle.main.loadNibNamed("razem", owner: self, options: nil)![0] as? RazemView{
                                razem.razemLabel.text = "L_RAZEM".localized()
                                
                                let cenaRazem = Float(self.razemNS[0].cena_s)!
                                let numCena = formatter1.string(from: NSNumber(value: cenaRazem))
                                razem.cenaRazem.text = "\(numCena! ) " + "L_PLN".localized()
                                
                                razem.wagaRazem.text = "\(self.razemNS[0].waga_s) " + "L_G".localized()
                                razem.kcalRazem.text = "\(self.razemNS[0].kcal_s) " + "L_KCAL".localized()
                                razem.frame = CGRect(x: 5, y: (105 * i) + 5,
                                                     width: Int(self.stolikView.frame.width - 10), height: 33)
                                self.stolikView.addSubview(razem)
                                //zapamietanie ceny razem dla "dostawy" i "do stolika"
                                Shared.shared.cenaRazem = self.razemNS[0].cena_s
                                Shared.shared.kosztOpakowan = self.razemNS[0].koszt_opakowan
                            }
                        }
                    }
                
                }
                
                //----------------------------------------------
                //sekcja przycisków
                //----------------------------------------------
                //pobranie danych wybranej restauracji
                self.location = StephencelisDB.instance.getMemory(memo: "mem_lok")
                var j = self.danieNS.count
                if Shared.shared.stolik[0].st_ile == "0"{
                   j = 0
                }
                
                if self.location![0].e != "0" {  //jeżeli jest id restauracji
                    //pobranie danych restauracji
                    let restauracja = StephencelisDB.instance.getRestaurantWithId(res: self.location![0].e)
                    
                    //komunikat o opakowaniach - label
                    var op:Int = 0
                    if  (restauracja[0].opak != "0.00"){
                        op += 50
                        //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
                        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                        
                        //formatowanie ceny opakowania
                        let cenaOpak = Float(restauracja[0].opak)!
                        let numOpak = formatter1.string(from: NSNumber(value: cenaOpak))
                        //razem.cenaRazem.text = "\(numOpak! ) " + "L_PLN".localized()
                        
                        let opakowaniaLabel = UILabel(frame: CGRect(x: 10, y: (105 * j) + op, width: Int(self.view.frame.size.width - 20), height: 45))
                        opakowaniaLabel.text = "* " + "L_DOLICZANIE_OPAKOWANIA".localized() + " " + numOpak! + " " + "L_PLN".localized()
                        opakowaniaLabel.textColor = UIColor.darkGray
                        opakowaniaLabel.font = UIFont.systemFont(ofSize: 14)
                        opakowaniaLabel.numberOfLines = 2
                        self.stolikView.addSubview(opakowaniaLabel)
                    }
                    
                    //przycisk "dostawa"
                    let dostawaButton = UIButton.init(type: .system)
                    dostawaButton.frame = CGRect(x: 10, y: (105 * j) + 50 + op, width: Int(self.view.frame.size.width - 20), height: 40)
                    dostawaButton.setTitle("L_ZAM_DOSTAWA".localized(), for: .normal)
                    dostawaButton.titleLabel?.textColor = UIColor.white
                    dostawaButton.tintColor = UIColor.white
                    dostawaButton.layer.cornerRadius = 5.0
                    if  (restauracja[0].dos == "1")&&(Shared.shared.stolik[0].st_ile != "0") {  //przycisk aktywny
                        dostawaButton.backgroundColor = Shared.shared.malinaColor
                        dostawaButton.addTarget(self, action: #selector(self.buttonDostawaClic(_ :)), for: .touchUpInside)
                    }else{                          //przycisk nieaktywny
                        dostawaButton.backgroundColor = Shared.shared.malinaColorLight
                    }
                    self.stolikView.addSubview(dostawaButton)
                    
                    //przycisk "do stolika"
                    let do_stolikaButton = UIButton.init(type: .system)
                    do_stolikaButton.frame = CGRect(x: 10, y: (105 * j) + 100 + op, width: Int(self.view.frame.size.width - 20), height: 40)
                    do_stolikaButton.setTitle("L_ZAM_DO_STOLIKA".localized(), for: .normal)
                    do_stolikaButton.titleLabel?.textColor = UIColor.white
                    do_stolikaButton.tintColor = UIColor.white
                    do_stolikaButton.layer.cornerRadius = 5.0
                    if  (restauracja[0].do_st == "1")&&(Shared.shared.stolik[0].st_ile != "0") {  //przycisk aktywny
                        do_stolikaButton.backgroundColor = Shared.shared.malinaColor
                        do_stolikaButton.addTarget(self, action: #selector(self.self.buttonDoStolikaClic(_ :)), for: .touchUpInside)
                    }else{                          //przycisk nieaktywny
                        do_stolikaButton.backgroundColor = Shared.shared.malinaColorLight
                    }
                    self.stolikView.addSubview(do_stolikaButton)
                    
                    //przycisk "rezerwacja stolików"
                    let rezerwacjaButton = UIButton.init(type: .system)
                    rezerwacjaButton.frame = CGRect(x: 10, y: (105 * j) + 150 + op, width: Int(self.view.frame.size.width - 20), height: 40)
                    rezerwacjaButton.setTitle("L_ZAM_REZERWACJA".localized(), for: .normal)
                    rezerwacjaButton.titleLabel?.textColor = UIColor.white
                    rezerwacjaButton.tintColor = UIColor.white
                    rezerwacjaButton.layer.cornerRadius = 5.0
                    if  restauracja[0].rez == "1" {  //przycisk aktywny
                        rezerwacjaButton.backgroundColor = Shared.shared.malinaColor
                        rezerwacjaButton.addTarget(self, action: #selector(self.self.buttonRezerwacjaClic(_ :)), for: .touchUpInside)
                    }else{                          //przycisk nieaktywny
                        rezerwacjaButton.backgroundColor = Shared.shared.malinaColorLight
                    }
                    self.stolikView.addSubview(rezerwacjaButton)
                    
                    //przycisk "zamówienia"
                    if  Shared.shared.zamowienia[0].za_id != "0"{
                        self.iloscZamowien =  Shared.shared.zamowienia.count
                    }else{
                        self.iloscZamowien = 0
                    }
                    let zamowieniaButton = UIButton.init(type: .system)
                    zamowieniaButton.frame = CGRect(x: 10, y: (105 * j) + 200 + op, width: Int(self.view.frame.size.width - 20), height: 40)
                    zamowieniaButton.setTitle("L_ZAMOWIENIA".localized() + " (" + "\(String(describing: self.iloscZamowien!))" + ")", for: .normal)
                    zamowieniaButton.titleLabel?.textColor = UIColor.white
                    zamowieniaButton.tintColor = UIColor.white
                    zamowieniaButton.layer.cornerRadius = 5.0
                    if  Shared.shared.zamowienia[0].za_id != "0"{  //przycisk aktywny
                        zamowieniaButton.backgroundColor = Shared.shared.malinaColor
                        zamowieniaButton.addTarget(self, action: #selector(self.buttonZamowieniaClic(_ :)), for: .touchUpInside)
                    }else{                          //przycisk nieaktywny
                        zamowieniaButton.backgroundColor = Shared.shared.malinaColorLight
                    }
                    self.stolikView.addSubview(zamowieniaButton)
                    
                }
            
            }
        
            
        }
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        
    }
    
    //----------------------------------------------------------
    //aktualizacja stolika na serwerze
    //----------------------------------------------------------
    func kasujStolik()  -> Int  {
        
        //pobranie lokalizacji z tabeli 'memory' - pamięci ustawień z widoku ustawiania lokalizacji
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        let resta = Int(location![0].e)!  //resta= id wybranej restauracji
        
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_na_stolik.php")
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["st_uz_id": Shared.shared.uz_id,
                          "st_re_id": String(resta),
                          "st_akcja": "3",] as [String: String]
        print(postString)
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
            //displayMessage(userMessage: "Coś poszło nie tak - przygotowanie requestu. Spróbuj ponownie.")
            return 0
        }
        
        let task = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("error======\(String(describing: error))")
                
            }
            
            //konwertowanie danych odebranych z serwera
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                print ("json:====== \(String(describing: json!))")
                //print ("json:==\(String(describing: json!["error_email"]!))")
                
                let st_ile = String(describing: json!["st_ile"]!)
                print("ss=\(st_ile)")
                Shared.shared.na_stoliku = Int(st_ile)
                
            } catch{
                print(error)
            }
        }
        task.resume()
        return 1
    }
    
    
    
    //----------------------------------------------------------
    //aktualizacja stolika na serwerze
    //----------------------------------------------------------
    func aktualizujStolik(akcja: String, indeks: Int)  -> Int  {
        
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_na_stolik.php")
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["st_id": Shared.shared.stolik[indeks].st_id,
                          "st_akcja": akcja,] as [String: String]
        print(postString)
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
            //displayMessage(userMessage: "Coś poszło nie tak - przygotowanie requestu. Spróbuj ponownie.")
            return 0
        }
        
        let task = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("error======\(String(describing: error))")

            }
            
            //konwertowanie danych odebranych z serwera
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                //print ("json:====== \(String(describing: json!))")
                //print ("json:==\(String(describing: json!["error_email"]!))")
                
                let st_ile = String(describing: json!["st_ile"]!)
                //print("ss=\(st_ile)")
                Shared.shared.na_stoliku = Int(st_ile)

            } catch{
                print(error)
            }
        }
        task.resume()
        return 1
    }
    
    //=========================================================
    //funkcja pobierająca JSONa z daniami na stoliku
    //=========================================================
    func downloadJSON_stolik(completed: @escaping () -> ()) {
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        //print("location=")
        //print(location![0].e)
        
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_stolik&uz_id=\(Shared.shared.uz_id!)&re=\(location![0].e)&lang=\(Localize.currentLanguage())")
        //print(url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    //print(data)
                    self.danieNS = try JSONDecoder().decode([DanieNaStole].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print ("JSON Error")
                }
            }
        }.resume()
    }
    
    //=========================================================
    //funkcja pobierająca JSONa z daniami RAZEM na stoliku
    //=========================================================
    func downloadJSON_stolik_razem(completed: @escaping () -> ()) {
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        //print("location=")
        //print(location![0].e)
        
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_stolik_razem&uz_id=\(Shared.shared.uz_id!)&re=\(location![0].e)&lang=\(Localize.currentLanguage())")
       // print(url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    //print(data)
                    self.razemNS = try JSONDecoder().decode([DaniaRazem].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print ("JSON Error")
                }
            }
            }.resume()
    }
    
    //komunikat "Brak restauracji"
    func displayAlertResta() {
        let alertViev = UIAlertController (title: "L_WYBIERZ_RESTA".localized(), message: "".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }
    
    //komunikat "Restauracja nieczynna"
    func displayAlertNieczynne() {
        let alertViev = UIAlertController (title: "L_PROSIMY_SKLADAC".localized() + ": " + Shared.shared.strefy[0].zamow_od + " - " + Shared.shared.strefy[0].zamow_do, message: "".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }
    
    //komunikat "minimalna kwota"
    func displayAlertKwota() {
        let alertViev = UIAlertController (title: "L_MUSI_PRZEKRACZAC".localized() + " " + Shared.shared.strefy[0].str_wart_min, message: "".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
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
    
    //=========================================================
    //funkcja pobierająca JSONa ze strefami dostaw
    //=========================================================
    func downloadJSON_strefy(completed: @escaping () -> ()) {
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_strefy&re_id=\(location![0].e)")
        //print(url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    //print(data)
                    self.strefy_dostawy = try JSONDecoder().decode([Strefa].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    Shared.shared.strefy = nil
                    print ("JSON Error")
                }
            }
            }.resume()
    }
}
