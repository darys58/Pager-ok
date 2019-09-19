//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import Localize_Swift
import ANLoader
import FBSDKLoginKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    var siec: Network?
    var reachability: Reachability?  //dostępność Internetu
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var memory1: [Memorydb]? = []         //filtry1 zapamiętane w bazie lokalnej
    var memory2: [Memorydb]? = []         //filtry2 zapamiętane w bazie lokalnej
    var activityIndicator = UIActivityIndicatorView()
    var danieNS = [DanieNaStole]()  //tablica dań na stoliku
    var powiadom = [Powiadomienie]() //tablica powiadomień (reklam) dla restauracji lub miasta
    var zamZam = [Zamowienie]()  //tablica zamówień
    var userUser = [User]() //dane zalogowanego użytkownika
    
    @IBOutlet weak var menu_tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu_tableView.delegate = self
        menu_tableView.dataSource = self
        
        //----- wskaźnik aktywności-----------
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        //------------------------------------
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //przeładowanie by po zmianie języka zaciągnąć tłumaczenie menu (i innych zmianach)
        menu_tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return 4 //ilość wierszy w 2 sekcji
        }else{
            if section == 2{
            return 3 //ilość wierszy w 3 sekcji
        }else{
            return 5 //ilość wierszy w 1 sekcji
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu_cell") as! MenuTableViewCell
        //print("menu - uz_id=\(Shared.shared.uz_id)")
        //żeby usunąć wyszrzanie wybranej celi
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if indexPath.section == 1{
            if indexPath.row == 0 {
                cell.label_title.text = "L_JEZYK".localized()
                cell.iconImage.image = UIImage(named: "jezyk.jpg")
            }
            if indexPath.row == 1 {
                cell.label_title.text = "L_USTAWIENIA".localized()
                cell.iconImage.image = UIImage(named: "ustawienia.jpg")
            }
            if indexPath.row == 2 {
                cell.label_title.text = "L_AKTUALIZUJ_DANE".localized()
                cell.iconImage.image = UIImage(named: "aktualizuj.jpg")
            }
            if indexPath.row == 3 {
                cell.label_title.text = "L_ON_BOARDING".localized()
                cell.iconImage.image = UIImage(named: "onboarding.jpg")
            }
            
        }else if indexPath.section == 2{
            //cell.label_title.text = title_arr3[indexPath.row]
            if indexPath.row == 0 {
                cell.label_title.text = "L_REGULAMIN".localized()
                cell.iconImage.image = UIImage(named: "regulamin.jpg")
            }
            if indexPath.row == 1 {
                cell.label_title.text = "L_POLITYKA".localized()
                cell.iconImage.image = UIImage(named: "polityka.jpg")
            }
            if indexPath.row == 2 { //Login
                if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){
                    cell.label_title.text = "L_WYLOGUJ".localized()
                    cell.label_title.textColor = .black
                    cell.iconImage.image = UIImage(named: "logowanie.jpg")
                }else{
                    cell.label_title.text = "L_ZALOGUJ".localized()
                    cell.label_title.textColor = .black
                    cell.iconImage.image = UIImage(named: "logowanie.jpg")
                }
            }
        }else {
            if indexPath.row == 0 { //Profil
                if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){
                    cell.label_title.text = "\(String(describing: Shared.shared.uz_login!))"
                    cell.label_title.textColor = .black
                    cell.iconImage.image = UIImage(named: "profil.jpg")
                }else{
                    cell.label_title.text = "L_PROFIL".localized()
                    cell.label_title.textColor = .gray
                    cell.iconImage.image = UIImage(named: "profil_s.jpg")
                }
            }
            if indexPath.row == 1 { //Składniki
                if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){
                    cell.label_title.text = "L_SKLADNIKI".localized()
                    cell.label_title.textColor = .black
                    cell.iconImage.image = UIImage(named: "skladniki.jpg")
                }else{
                    cell.label_title.text = "L_SKLADNIKI".localized()
                    cell.label_title.textColor = .gray
                    cell.iconImage.image = UIImage(named: "skladniki_s.jpg")
                }
            }
            if indexPath.row == 2 { //Stolik
                if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){
                    cell.label_title.text = "L_STOLIK".localized()
                    cell.label_title.textColor = .black
                    cell.iconImage.image = UIImage(named: "stolik.jpg")
                }else{
                    cell.label_title.text = "L_STOLIK".localized()
                    cell.label_title.textColor = .gray
                    cell.iconImage.image = UIImage(named: "stolik_s.jpg")
                }
            }
            
            
            if indexPath.row == 3 { //Ulubione
                if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){
                    cell.label_title.text = "L_ULUBIONE".localized()
                    cell.label_title.textColor = .black
                    cell.iconImage.image = #imageLiteral(resourceName: "ulubione")
                }else{
                    cell.label_title.text = "L_ULUBIONE".localized()
                    cell.label_title.textColor = .gray
                    cell.iconImage.image = #imageLiteral(resourceName: "ulubione_s")
                }
            }
            
            if indexPath.row == 4 { //Promocje
                if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){
                    cell.label_title.text = "L_PROMOCJE".localized()
                    cell.label_title.textColor = .black
                    cell.iconImage.image = #imageLiteral(resourceName: "powiadomienia")
                }else{
                    cell.label_title.text = "L_PROMOCJE".localized()
                    cell.label_title.textColor = .gray
                    cell.iconImage.image = #imageLiteral(resourceName: "powiadomienia_s")
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 37
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 19
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Profil
        if indexPath.section == 0{
            if indexPath.row == 0 {
                self.reachability = Reachability.init()
                if((self.reachability!.connection) != .none){ //jeżeli jest Internet
                    if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){ //zalogowany
                        //----- wskaźnik aktywności-------
                        self.activityIndicator.startAnimating()
                        UIApplication.shared.beginIgnoringInteractionEvents()
                        //---------------------------------
                        //pobranie danych użytkownika
                        self.downloadJSON_user{
                            //i zapisanie ich do pamięci podręcznej
                            Shared.shared.user = self.userUser
                       
                            //====== wskaźnik aktywności stop ====
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            //-------------------------------------
                        self.performSegue(withIdentifier: "sbProfil", sender: self) //przejście Profil
                        }
                        //====== wskaźnik aktywności stop ==== gdyby JSON zgłosił error
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        //-------------------------------------
                    }else{
                        displayAlertLog()
                    }
                }else{ //jeżeli nie ma Internetu
                    displayAlert()
                }
            }
        }
        
        //Składniki
        if indexPath.section == 0{
            if indexPath.row == 1 {
                if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){ //naciśnięto Składniki
                    performSegue(withIdentifier: "sbIngrediens", sender: self) //przejście 
                }else{
                    displayAlertLog()
                }
            }
        }
        
        //Stolik
        if indexPath.section == 0{
            if indexPath.row == 2 {
                //pobranie lokalizacji z tabeli 'memory->mem_lok'
                location = StephencelisDB.instance.getMemory(memo: "mem_lok")
                
                if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){
                    if location![0].e != "0" {
                        //====== wskaźnik aktywności start ======
                        self.activityIndicator.startAnimating()
                        UIApplication.shared.beginIgnoringInteractionEvents()
                        //---------------------------------------
                        
                        Shared.shared.dolaczMenu = "0"  //zerowanie dołaczania menu przy rezerwacji stolika
                        Shared.shared.czasMogeJesc = nil  //zerowanie czasuMogeJesc przy rezerwacji stolika
                        Shared.shared.kod_stolika = nil //zerowanie kodu stolika
                        
                        //pobranie dań na stoliku [danieNS]
                        self.downloadJSON_stolik{
                            //i zapisanie ich do pamięci podręcznej
                            Shared.shared.stolik = self.danieNS
                            
                            //pobranie zamówień [Zamowienie]
                            self.downloadJSON_zamowienia{
                                //i zapisanie ich do pamięci podręcznej
                                Shared.shared.zamowienia = self.zamZam
                                
                                //====== wskaźnik aktywności stop ====
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                //-------------------------------------
                                
                                //przejście do stolika
                                self.performSegue(withIdentifier: "sbStolik", sender: self) //przejście
                                
                            }
                        }
                    
                    }else{
                        displayAlertResta()
                    }
                }else{
                    displayAlertLog()
                }
            }
        }
        
        
        //Ulubione
        if indexPath.section == 0{
            if indexPath.row == 3 {
                if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){
                    if Shared.shared.lista == "1"{
                        performSegue(withIdentifier: "sbUlubione01", sender: self)
                    }else{
                        performSegue(withIdentifier: "sbUlubione0", sender: self) //do ulubionych
                    }
                }else{
                    displayAlertLog()
                }
            }
        }
        
        //Promocje
        if indexPath.section == 0{
            if indexPath.row == 4 {
                self.reachability = Reachability.init()
                if((self.reachability!.connection) != .none){ //jeżeli jest Internet
                    //pobranie lokalizacji z tabeli 'memory->mem_lok'
                    location = StephencelisDB.instance.getMemory(memo: "mem_lok")
                    
                    if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){
                        if location![0].e != "0" { //jeżeli jest wybrana restauracja
                            //====== wskaźnik aktywności start ======
                            self.activityIndicator.startAnimating()
                            UIApplication.shared.beginIgnoringInteractionEvents()
                            //---------------------------------------
                            //pobranie powiadomień (reklam)  [danieNS]
                            self.downloadJSON_powiadom_re{
                                //i zapisanie ich do pamięci podręcznej
                                Shared.shared.powiadomienia = self.powiadom
                                
                                //====== wskaźnik aktywności stop ====
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                self.performSegue(withIdentifier: "sbPowiadomienia", sender: self) //do powiadom
                                //-------------------------------------
                            }
                        }else{ //pobranie powiadomień (reklam) dla miasta
                            //====== wskaźnik aktywności start ======
                            self.activityIndicator.startAnimating()
                            UIApplication.shared.beginIgnoringInteractionEvents()
                            //---------------------------------------
                            //pobranie powiadomień (reklam)  [danieNS]
                            self.downloadJSON_powiadom_mia{
                                //i zapisanie ich do pamięci podręcznej
                                Shared.shared.powiadomienia = self.powiadom
                                
                                //====== wskaźnik aktywności stop ====
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                self.performSegue(withIdentifier: "sbPowiadomienia", sender: self) //do powiadom
                            }
                        }
                    }else{
                        displayAlertLog()
                    }
                }
            }
        }
 
        //Język
        if indexPath.section == 1{
            if indexPath.row == 0 {
                performSegue(withIdentifier: "sbLang", sender: self) //przejście do LangVC
            }
        }
        //Ustawienia
        if indexPath.section == 1{
            if indexPath.row == 1 {
                performSegue(withIdentifier: "sbSettings", sender: self) //przejście do SettingsTableVC
            }
        }
        
        //Zaktualizuj dane
        if indexPath.section == 1{
            if indexPath.row == 2 {
                self.reachability = Reachability.init()
                if((self.reachability!.connection) != .none){ //jeżeli jest Internet
                  siec = Network()
                    
                    //duży, malinowy wskaźnik ładowania i zwłoka
                    ANLoader.showLoading("Loading", disableUI: true)
                    ANLoader.activityBackgroundColor = Shared.shared.malinaColor
                    ANLoader.showFadeOutAnimation = true
                    ANLoader.viewBackgroundDark = true
                    
                    //skasowanie wszystkich restauracji z tabeli 'restauracje'
                   _ = StephencelisDB.instance.deleteRestauracjeAll()
                    
                    //wczytanie wszystkich restauracji
                   siec!.importujRestauracje()
   
                    //Zwłoka żeby przeładowały sie restauracje i żeby sprawdzic czy rest jest
                    var rrr = 0
                    while Shared.shared.ileRestaJSON != rrr {
                        sleep(1) //opóźnienie = 1 sek.
                        rrr = Shared.shared.liczResta + 1 //ilość wczytanych resta - licznik w Network.swift
                    }
                    
                    //skasowanie wszystkich podkategorii z tabeli 'podkategorie'
                    _ = StephencelisDB.instance.deletePodkategorieAll()
                    
                    //wczytanie wszystkich podkategorii
                    siec!.importujPodkategorie()
    
                    //wczytanie (update) aktualnych wartości filtrów z www
                     siec!.importujFiltr()
    
                    //skasowanie wszystkich dań z tabeli 'dania'
                    _ = StephencelisDB.instance.deleteDaniaAll()
  
                    //pobranie lokalizacji z tabeli 'memory->mem_lok'
                    location = StephencelisDB.instance.getMemory(memo: "mem_lok")

                    //== pobranie danych filtrów z tabeli 'memory'
                    //mem_filtr1 (a:czasmin, b:czasmax, c:wagamin, d:wagamax, e:kcalmin, f:kcalma)
                    memory1 = StephencelisDB.instance.getMemory(memo: "mem_filtr1")
                    //mem_filtr2 (a:cenamin, b:cenamax, c:dla
                    memory2 = StephencelisDB.instance.getMemory(memo: "mem_filtr2")
                    
                   
                    Shared.shared.liczDania = 0 //zerowanie liczby pobranych dań
                    
                    //czy jest restauracja? bo jeśli nie to załaduj domyślne (wszystkie z Konina)
                    if self.location![0].e != "0" { //jeżeli aktualnie nie są wybrane "Wszystkie" rest w mieście, tzn. jeżeli wybrana jest konkretna restauracja
                        let czy_jest_rest = StephencelisDB.instance.czyRestauracja(rest: self.location![0].e)
                            print("jaka rest = ")
                            print (czy_jest_rest)
                            if czy_jest_rest > 0{ //wybrana restauracja istnieje w bazie (czy_jest_rest = 1)
                                _ = self.siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(self.location![0].a)&mia_id=\(self.location![0].c)&rest=\(self.location![0].e)&lang=\(Localize.currentLanguage())")
                            }else{ //restauracji nie ma już w bazie www (bo np. została usunięta) - sprawdzenie czy jest jeszcze miasto (bo mogło zostac usunięte)
                                let czy_jest_miasto = StephencelisDB.instance.czyMiasto(miaid: self.location![0].c)
                                print("czy jest miasto = ")
                                print (czy_jest_miasto)
                                if czy_jest_miasto > 0{ //wybrane miasto istnieje w bazie
                                    print("jest miasto!")
                                    //update lokalizacji w bazie lokalnej - nowa lokalizacja zapisana do tabeli 'memory' rekord 'mem_lok' - ustawić wszystkie restauracje w mieście
                                    _ = StephencelisDB.instance.updateMemory(mem:"mem_lok", a: self.location![0].a, b: self.location![0].b, c: self.location![0].c, d: self.location![0].d, e: "0", f: "00")
                                    
                                    _ = self.siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(self.location![0].a)&mia_id=\(self.location![0].c)&lang=\(Localize.currentLanguage())")
                                
                                }else{//jeżeli nie ma miasta to ustaw wartości domyślne (Konin)
                                    print("nie ma miasta - domyślnie Konin")
                                    //update lokalizacji w bazie lokalnej - nowa lokalizacja zapisana do tabeli 'memory' rekord 'mem_lok' - ustawić lokalizacje domyślną - Konin
                                    _ = StephencelisDB.instance.updateMemory(mem: "mem_lok", a: "14", b: "wielkopolskie", c: "1", d: "Konin", e: "0", f: "00")
                                    
                                    _ = self.siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=14&mia_id=1&rest=0&lang=\(Localize.currentLanguage())")
                                }
                            }
                        }else{ //są wybrane "Wszystkie"
                        //pobranie dań dla wszystkich restauracji w miescie (bez filtrów bo skasowane i uaktualnione)
                        _ = self.siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(self.location![0].a)&mia_id=\(self.location![0].c)&rest=\(self.location![0].e)&lang=\(Localize.currentLanguage())")
                        }

                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                
                        //Zwłoka do czasu pobrania wszystkich dań z internetu do bazy lokalnej
                        var aaa = 0
                        while Shared.shared.ileDanJSON != aaa {
                            sleep(1) //opóźnienie = 1 sek.
                            aaa = Shared.shared.liczDania + 1 //ilość wczytanych dań - licznik w Network.swift
                            print ("dania=")
                            print (aaa)
                        }
                        
                        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.hideLoader), userInfo: nil, repeats: false)
                    
                        AppDelegate.refresh_list_meal = true
                        
                        //przejęcie do listy dań - zaremowane bo po skasowaniu dań w bazie (powyżej w kodzie) dania giną również na wyświetlanej liście
                        self.performSegue(withIdentifier: "unwindToParentFromMenu", sender: self)
                        
                    }
                    
                    
                    
                }else{ //jeżeli nie ma Internetu
                    displayAlert()
                }
            }
        }
        
        //OnBording
        if indexPath.section == 1{
            if indexPath.row == 3 {
                performSegue(withIdentifier: "sbOnBording", sender: self) //przejście do KaruzelaOB
            }
        }
        
        //Regulamin
        if indexPath.section == 2{
            if indexPath.row == 0 {
                self.reachability = Reachability.init()
                if((self.reachability!.connection) != .none){ //jeżeli jest Internet
                    performSegue(withIdentifier: "sbRegulamin", sender: self) //przejście do
                }else{ //jeżeli nie ma Internetu
                    displayAlert()
                }
            }
        }
        
        //Polityka prywatności
        if indexPath.section == 2{
            if indexPath.row == 1 {
                self.reachability = Reachability.init()
                if((self.reachability!.connection) != .none){ //jeżeli jest Internet
                    performSegue(withIdentifier: "sbPolityka", sender: self) //przejście do
                }else{ //jeżeli nie ma Internetu
                    displayAlert()
                }
    
            }
        }
        
        //Wylogowanie
        if indexPath.section == 2{
            if indexPath.row == 2 {
                if (Shared.shared.uz_id != nil) && (Shared.shared.uz_id != ""){ //naciśnięto Wyloguj
                    
                    //----- wskaźnik aktywności-------
                    self.activityIndicator.startAnimating()
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    //---------------------------------
                    
                    //usunięcie danych użytkownika do bazy
                    _ = StephencelisDB.instance.updateMemory(mem: "mem_user", a: "", b: "", c: "", d: "", e: "", f: "")
                    
                    //zerowanie pamięci danych zalogowanego
                    Shared.shared.uz_id = ""
                    Shared.shared.uz_login = "" //było nil
                    Shared.shared.uz_email = ""
                    
                    //wczytanie dań niezalogowanego
                    self.reachability = Reachability.init()
                    if((self.reachability!.connection) != .none){ //jeżeli jest Internet
                        
                        siec = Network()
                        
                        /*    //czy? vvvv  nie zdąża załadować       //skasowanie wszystkich restauracji z tabeli 'restauracje'
                         _ = StephencelisDB.instance.deleteRestauracjeAll()
                         //wczytanie wszystkich restauracji
                         siec!.importujRestauracje()
                         
                         //skasowanie wszystkich podkategorii z tabeli 'podkategorie'
                         _ = StephencelisDB.instance.deletePodkategorieAll()
                         //wczytanie wszystkich podkategorii
                         siec!.importujPodkategorie()
                         
                         //wczytanie (update) aktualnego zakresu wartości filtrów z www (od min do max)
                         siec!.importujFiltr()
                         //czy? ^^^^
                         */
                        //skasowanie wszystkich dań z tabeli 'dania'
                        _ = StephencelisDB.instance.deleteDaniaAll()
                        
                        //skasowanie wszystkich kategorii składników
                        _ = StephencelisDB.instance.deleteRodzajeAll()
                        
                        //pobranie lokalizacji z tabeli 'memory->mem_lok'
                        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
                        
                        
                        //czy jest restauracja? bo jeśli nie to załaduj domyślne (wszystkie z Konina)(bez filtrów bo skasowane i uaktualnione)
                        if location![0].e != "0" { //jeżeli aktualnie nie są wybrane "Wszystkie" rest w mieście
                            let czy_jest_rest = StephencelisDB.instance.czyRestauracja(rest: location![0].e)
                            if czy_jest_rest > 0{ //wybrana restauracja istnieje w bazie (czy_jest_rest = 1)
                                _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz=&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())")
                            }else{ //restauracji nie ma już w bazie www (bo np. została usunięta) - ładuje domyślne
                                _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&woj_id=14&mia_id=1&rest=0&lang=\(Localize.currentLanguage())")
                            }
                        }else{ //są wybrane "Wszystkie"
                            //pobranie dań dla wszystkich restauracji w miescie (bez filtrów bo skasowane i uaktualnione)
                            _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())")
                        }
                        
                        menu_tableView.reloadData()
                        
                        //wylogowanie facebooka z apki
                        let loginManager = FBSDKLoginManager()
                        loginManager.logOut()
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                            //ustawienie znacznika konieczności przeładowania listy dań
                           
                            //Zwłoka do czasu pobrania wszystkich dań z internetu do bazy lokalnej
                            var aaa = 0
                            while Shared.shared.ileDanJSON != aaa {
                                sleep(1) //opóźnienie = 1 sek.
                                aaa = Shared.shared.liczDania + 1 //ilość wczytanych dań - licznik w Network.swift
                            }
                            
                            AppDelegate.refresh_list_meal = true
                            //zaznaczenie że menu boczne zostało zamknięte
                            AppDelegate.menu_bool = true
                            //----- wskaźnik aktywności-------
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            //---------------------------------
                            //przejście do listy dań
                            self.performSegue(withIdentifier: "unwindToParentFromMenu", sender: self)
                        }
                    }else{ //jeżeli nie ma Internetu
                        displayAlert()
                    }
                    
                    
                }else{ //Zaloguj
                    performSegue(withIdentifier: "sbLogin", sender: self) //przejście do logowania
                }
            }
        }
        
    }
    
    //=========================================================
    //funkcja pobierająca JSONa z promocjami (reklamami) dla miasta
    //=========================================================
    func downloadJSON_powiadom_mia(completed: @escaping () -> ()) {
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        //print("location=")
        //print(location![0].c)
        
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_powiadomienia&uz_id=\(Shared.shared.uz_id!)&mia_id=\(location![0].c)&lang=\(Localize.currentLanguage())")
        //print(url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    //print(data)
                    self.powiadom = try JSONDecoder().decode([Powiadomienie].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    Shared.shared.stolik = nil
                    print ("JSON Error promocje")
                }
            }
            }.resume()
    }
    
        
    //=========================================================
    //funkcja pobierająca JSONa z promocjami (reklamami) dla restauracji
    //=========================================================
    func downloadJSON_powiadom_re(completed: @escaping () -> ()) {
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        //print("location=")
        //print(location![0].e)
        
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_powiadomienia&uz_id=\(Shared.shared.uz_id!)&re=\(location![0].e)&lang=\(Localize.currentLanguage())")
        //print(url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    //print(data)
                    self.powiadom = try JSONDecoder().decode([Powiadomienie].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    Shared.shared.stolik = nil
                    print ("JSON Error powiadomienia")
                }
            }
        }.resume()
    }
        
        
    //=========================================================
    //funkcja pobierająca JSONa z danymi użytkownika zalogowanego
    //=========================================================
    func downloadJSON_user(completed: @escaping () -> ()) {
        
        let url = URL(string: "https://www.cobytu.com/cbt.php?d=ios_user&uz_id=\(Shared.shared.uz_id!)")
        //print(url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    //print(data)
                    self.userUser = try JSONDecoder().decode([User].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    Shared.shared.user = nil
                    print ("JSON Error user")
                }
            }
        }.resume()
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
                    Shared.shared.stolik = nil
                    print ("JSON Error stolik")
                }
            }
        }.resume()
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
                    print ("JSON Error zamówienia")
                }
            }
            }.resume()
    }
    
    //ukrycie wskaźnika ładowania
    @objc func hideLoader(){
        ANLoader.hide()
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    //komunikat "Brak Internetu"
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
    }
    
    //komunikat "Brak logowania"
    func displayAlertLog() {
        let alertViev = UIAlertController (title: "L_BRAK_DOSTEPU".localized(), message: "L_DOSTEP_PO_LOGOWANIU".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
    }
    
    //komunikat "Brak restauracji"
    func displayAlertResta() {
        let alertViev = UIAlertController (title: "L_WYBIERZ_RESTA".localized(), message: "".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }
 
/*    func displayAlertResta() -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "L_WYBIERZ_RESTA".localized(), message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
            alertController.addAction(cancel)
            
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //jak zrobić przejście bezpośrednio do Lokalizacji ??????????
                self.performSegue(withIdentifier: "segueToParent", sender: self)
                //code
                print ("OK")
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
*/
 }
