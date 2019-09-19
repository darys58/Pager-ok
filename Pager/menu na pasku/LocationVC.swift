//
//  LocationVC.swift
//  Pager
//
//  Created by darys on 29.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Localize_Swift

class LocationVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var pickerView1: UIPickerView!    
    @IBOutlet weak var pickerView2: UIPickerView!    
    @IBOutlet weak var pickerView3: UIPickerView!
    //@IBOutlet weak var skanujLabel: UILabel!
    //@IBOutlet weak var zatwierdzLabel: UIButton!
    @IBOutlet weak var zatwierdzButton: UIBarButtonItem!
    @IBOutlet weak var skanujQR: UIButton!
    var siec: Network?
    
    var wojewodztwa = [String]()    //tablice danych dla pickerów
    var miasta = [String]()
    var restauracje = [String]()
    
    var restauracja: [Restaurantdb] = []  //dane restauracji wybranej w lokalizacji
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var memory1: [Memorydb]? = []         //filtry1 zapamiętane w bazie lokalnej
    var memory2: [Memorydb]? = []         //filtry2 zapamiętane w bazie lokalnej
    
    var woj = ""        //zmienne lokalizacyjne
    var miasto = ""
    var resta = ""
    
    var progres = UIProgressView()
    var activityIndicator = UIActivityIndicatorView() //wskaźnik aktywności
    var reachability: Reachability?  //dostępność Internetu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "L_LOKALIZACJA".localized()
        zatwierdzButton.title = "L_ZATWIERDZ".localized()
        skanujQR.setTitle("L_SKANUJ".localized(), for: .normal)
            //zatwierdzLabel.setTitle("L_ZAT".localized(), for: .normal)
        //skanujLabel.text = "L_SKANUJ".localized()
        self.view.backgroundColor = Shared.shared.malinaColor
        
        //pobranie lokalizacji z tabeli 'memory' - pamięci ustawień z widoku ustawiania lokalizacji
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")

        //pobranie odpowiednich danych z tabeli 'restauracje'  dla pickerów lokalizacji
        wojewodztwa = StephencelisDB.instance.getDistrict()
        miasta = StephencelisDB.instance.getCity(wojid: location![0].b)
        restauracje = StephencelisDB.instance.getRestaurants(miaid: location![0].d)

        //ustawienie lokalnych zmiennych lokalizacyjnych
        woj = location![0].b    //woj
        miasto = location![0].d //miasto
        resta = location![0].f  //resta

        //ustawienie pickerów na wartości pobrane z pamięci pickerów (z tabeli 'lokalizacja')
        pickerView1.selectRow(wojewodztwa.index(of: woj)!, inComponent: 0, animated: true)
        pickerView2.selectRow(miasta.index(of: miasto)!, inComponent: 0, animated: true)
        pickerView3.selectRow(restauracje.index(of: resta)!, inComponent: 0, animated: true)
    
       //wskaźnik aktywności
        activityIndicator.center = CGPoint.init(x: self.view.frame.size.width/2, y: 200)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(activityIndicator)
        
/*      progres.center = CGPoint.init(x: self.view.frame.size.width/2, y: 250)
        progres.progressViewStyle = .bar
        progres.progressTintColor = UIColor.lightGray
        progres.trackTintColor = .blue
        progres.setProgress(0.5, animated: true)
        self.view.addSubview(progres)
  */  }
    
    //podpowiedź pod przyciskiem skanowania
    @IBAction func alertCoSkanowac(_ sender: Any) {
        displayAlertQR()
    }
    
    
    //========================================
    //zatwierdzenie ustawionej lokalizacji - obsługa przycisku "Zatwierdzenie lokalizacji"
    //========================================
    @IBAction func ustaw(_ sender: Any) {
        var rest: String = ""
        var mia_id: String = ""
        var woj_id: String = ""
        
        //pobranie danych restauracji z tabeli 'restauracje' dla wybranej lokalizacji
        if resta == "00" { //"00" oznacza "Wszystkie"
            rest = "0"
            restauracja = StephencelisDB.instance.getMiasto(mia: miasto)
            mia_id = restauracja[0].mia_id
            woj_id = restauracja[0].woj_id
        }else {
            restauracja = StephencelisDB.instance.getRestaurant(res: resta)
            rest = restauracja[0].reid
            mia_id = restauracja[0].mia_id
            woj_id = restauracja[0].woj_id
            Shared.shared.mogeJesc = restauracja[0].moge
        }
        
        //sprawdzenie dostępu do Internetu
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
           siec = Network()
            
            //----- wskaźnik aktywności-----------
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            //-------------------------------------
            
            //skasowanie wszystkich restauracji z tabeli 'restauracje'
            _ = StephencelisDB.instance.deleteRestauracjeAll()
            
            //wczytanie wszystkich restauracji
            siec!.importujRestauracje()
            
            //nowa lokalizacja zapisana do tabeli 'memory->mem_lok'
            _ = StephencelisDB.instance.updateMemory(mem:"mem_lok", a: woj_id, b: woj, c: mia_id, d: miasto, e: rest, f: resta)
            
            //== pobranie danych filtrów z tabeli 'memory'
            //mem_filtr1 (a:czasmin, b:czasmax, c:wagamin, d:wagamax, e:kcalmin, f:kcalma)
            memory1 = StephencelisDB.instance.getMemory(memo: "mem_filtr1")
            //mem_filtr2 (a:cenamin, b:cenamax, c:dla
            memory2 = StephencelisDB.instance.getMemory(memo: "mem_filtr2")
            
            _ = StephencelisDB.instance.deleteDaniaAll()   //zerowanie tabeli 'dania' w bazie lokalnej
            
            //pobranie dań z serwera dla wybranej restauracji
            
            if Shared.shared.uz_id != nil{
            _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(woj_id)&mia_id=\(mia_id)&rest=\(rest)&dla=\(memory2![0].c)&czasmin=\(memory1![0].a)&czasmax=\(memory1![0].b)&cenamin=\(memory2![0].a)&cenamax=\(memory2![0].b)&wagamin=\(memory1![0].c)&wagamax=\(memory1![0].d)&kcalmin=\(memory1![0].e)&kcalmax=\(memory1![0].f)&lang=\(Localize.currentLanguage())")
            }else{
                _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&woj_id=\(woj_id)&mia_id=\(mia_id)&rest=\(rest)&dla=\(memory2![0].c)&czasmin=\(memory1![0].a)&czasmax=\(memory1![0].b)&cenamin=\(memory2![0].a)&cenamax=\(memory2![0].b)&wagamin=\(memory1![0].c)&wagamax=\(memory1![0].d)&kcalmin=\(memory1![0].e)&kcalmax=\(memory1![0].f)&lang=\(Localize.currentLanguage())")
            }
           //print(Shared.shared.uz_id)
            //zwłoka na pobranie danych z Internetu
            
          
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in //UIApplication.shared.endIgnoringInteractionEvents()
                //print("lang =  \(Localize.currentLanguage())")
                
                //Zwłoka do czasu pobrania wszystkich dań z internetu do bazy lokalnej
                var aaa = 0
                while Shared.shared.ileDanJSON != aaa {
                    sleep(1) //opóźnienie = 1 sek.
                    aaa = Shared.shared.liczDania + 1 //ilość wczytanych dań - licznik w Network.swift       
                }
                
                //jeżeli lista dań dla miasta (bo np. restauracja została usunięta)
                //w "Aktalizuj dane" w Menu zrobiłem to inaczej, sprawdzam to w apce
                if Shared.shared.czy_rest == 0{
                    self.resta = "00"  //"00" oznacza "Wszystkie"
                    rest = "0"
                }
                
                //nowa lokalizacja zapisana do tabeli 'memory->mem_lok'
                _ = StephencelisDB.instance.updateMemory(mem:"mem_lok", a: woj_id, b: self.woj, c: mia_id, d: self.miasto, e: rest, f: self.resta)
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                AppDelegate.refresh_list_meal = true
                Shared.shared.strefa = 0 //domyślne ustawienie strefy dostawy(również w QRLocation i AppDelegate)
                Shared.shared.platnosc = 0 //0 - brak danych - domyślne ustawienie sposobu płatności za dostawę
                
                self.dismiss(animated: true, completion: nil)
            }
        }else{ //jeżeli nie ma Internetu
            displayAlert()
        }
     
    }
    
    
    @IBAction func exitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //============================
    //ustawienie pickerów
    //============================
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows: Int = wojewodztwa.count
        if pickerView == pickerView2{
            countrows = self.miasta.count
        }
        if pickerView == pickerView3{
            countrows = self.restauracje.count
        }
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1{
            let titleRow = wojewodztwa[row]
                //print ("titleRow wojewo=\(titleRow)")
            return titleRow
        }
        if pickerView == pickerView2{
            let titleRow = miasta[row]
                //print ("titleRow miasta=\(titleRow)")
            return titleRow
        }
        if pickerView == pickerView3{
            var titleRow = restauracje[row]
            if titleRow == "00" {titleRow = "L_WSZYSTKIE".localized()}
                //print ("titleRow restaur=\(titleRow)")
            return titleRow
        }
        return ""
    }
    
    
    //kiedy dokonano wyboru któregoś z pickerów - aktualizacja pozostałych pickerów
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1{
            miasta = StephencelisDB.instance.getCity(wojid: self.wojewodztwa[row]) //pobranie miast
            pickerView2.reloadComponent(0)                              //wymiana miast
            pickerView2.selectRow(0, inComponent: 0, animated: true)    //ustawia wybór miasta na początek
            restauracje = StephencelisDB.instance.getRestaurants(miaid: miasta[0]) //pobranie restauracji
            pickerView3.reloadComponent(0)
            pickerView3.selectRow(0, inComponent: 0, animated: true)
            woj = wojewodztwa[row]
            miasto = miasta[0]
            resta = restauracje[0]
            //print ("woj=\(woj),  \(miasto),\(resta)")
           
        }
        if pickerView == pickerView2{
            restauracje = StephencelisDB.instance.getRestaurants(miaid: self.miasta[row]) //pobranie restauracji
            pickerView3.reloadComponent(0)
            pickerView3.selectRow(0, inComponent: 0, animated: true)
            miasto = miasta[row]
            resta = restauracje[0]
            //print ("woj=\(woj), \(miasto),\(resta)")
        }
        if pickerView == pickerView3{
            resta = restauracje[row]
            //print ("woj=\(woj),\(miasto),\(resta)")
        }
    }
    
  
    @IBAction func skanujButton(_ sender: UIButton) {

    }
    
    //komunikat "Brak Internetu"
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }
    
    //info o kodzie QR
    func displayAlertQR() {
        let alertViev = UIAlertController (title: "L_ON_BOARDING".localized(), message: "L_ALERT_QR".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }
    

    

}
