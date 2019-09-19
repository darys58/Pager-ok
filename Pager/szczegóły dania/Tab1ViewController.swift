//
//  Tab1ViewController.swift
//  Pager
//
//  Created by darys on 09.01.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Localize_Swift


class Tab1ViewController: UIViewController, BEMCheckBoxDelegate{
    
    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!    
    //@IBOutlet weak var opisLabel: UILabel!
    @IBOutlet weak var cenaLabel: UILabel!
    @IBOutlet weak var czasLabel: UILabel!
    @IBOutlet weak var wagaLabel: UILabel!
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var iloscLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var wybierzLabel: UILabel!
    @IBOutlet weak var uwagaImage: UIImageView!
    @IBOutlet weak var opisTextView: UITextView!
    
    
    @IBOutlet weak var myScrollView: UIView!  //uchwyt do widoku skrollowanego
    
    var meal = [MealState]()            //dane z JSONa - szczegóły dania pobrane z www
    var meal_resta = [MealResta]()      //dane z JSONa - szczegóły restauracji pobrane z www
    var meal_sklad = [MealSklad]()      //dane z JSONa - składniki dania
    var meal_opinie = [MealOpinie]()    //dane z JSONa - opinie o daniu
    var moje_meal_opinie = [MealOpinie]()    //dane z JSONa - opinie o daniu
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var memory: [Memorydb]? = []        //id dania zapamiętane w bazie lokalnej
    var nh: Network?                    //do pobrania zdjęcia
    var resta: Int = 0                     //id wybranej restauracji
    var btnWersja = UIButton() //button wersja dania
    let btnWariant1 = UIButton() //button wariant1
    let btnWariant2 = UIButton() //button wariant2
    var waga: Int = 0       //waga po przeliczeniu po zmianach
    var kcal: Int = 0       //kcal po przeliczeniu po zmianach
    var cena: Float = 0.00  //cena po przeliczeniu po zmianach
    var reachability: Reachability?  //dostępność Internetu
    var activityIndicator = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//self.myScrollView.frame.size.height = CGFloat(100)
        //== pobranie id dania i ścieżki do foto i alergeny z tabeli 'memory'
        memory = StephencelisDB.instance.getMemory(memo: "mem_danie") //a:id dania, b:imageName, c: alergeny, d: nazwa
        //print ("memory w tab1 =\(memory![0].b)")
        
        //pobranie lokalizacji z tabeli 'memory' - pamięci ustawień z widoku ustawiania lokalizacji
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        resta = Int(location![0].e)!  //resta= id wybranej restauracji
        
        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
        
        //----- wskaźnik aktywności-----------
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        //------------------------------------
       
        
        //----- wskaźnik aktywności-------
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        //---------------------------------
        downloadJSON {
            //print(self.meal[0])
            //print("Success")
//self.myScrollView.frame.size.height = CGFloat(1000)
            //----- wskaźnik aktywności-------
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            //---------------------------------
            if self.memory![0].b == "co.jpg" {
                self.fotoImageView.image = UIImage(named: "brak3.jpg")
            }else{
                let bez_m = self.memory![0].b.replacingOccurrences(of: "_m.", with: ".") //nazwa foto bez _m.
                //== pobranie zdjęcia z sieci i wstawienie do widoku (b - ścieżka do pliku)
                self.nh = Network()
                self.nh?.getPictureFromServer(imageName: bez_m, callback: { (image:UIImage)->Void in
                    DispatchQueue.main.async{
                        self.fotoImageView.image = image
                    }
                })
            }
//print("wysokość myScrollView 1")
//print(self.myScrollView.frame.size.height)
            //== ukrycie danych na pasku wstawiania dań do stolika
            self.plusButton.isHidden = true
            self.minusButton.isHidden = true
            self.iloscLabel.isHidden = true
            
            //cena dania
            if (self.resta == 0) && (self.meal[0].cena == "wr"){ //jeżeli kilka restauracji i cen
                self.cenaLabel.isHidden = true
                self.wybierzLabel.text = "L_CENA_ZALEZY".localized()
                self.wybierzLabel.sizeToFit()
            }else{
                self.wybierzLabel.isHidden = true
                //formatowanie i wyświetlanie ceny
                let numCena = formatter1.string(from: NSNumber(value: Float(self.meal[0].cena)!))
                self.cenaLabel.text = "\(numCena! ) " + "L_PLN".localized()
                self.cena = Float(self.meal[0].cena)! //potrzebne do obsługi stolika
                
                //self.cenaLabel.text = self.meal[0].cena + " " + "L_PLN".localized()
                //self.cena = Float(self.meal[0].cena.replacingOccurrences(of: ",", with: "."))!
            }
            
            //== wstawienie danych do widoku
            
            //self.titleLabel.text = self.meal[0].da_nazwa
            self.opisTextView.font = UIFont(name: "Arial", size: 18)
            self.opisTextView.textColor = UIColor.gray
            self.opisTextView.text = self.meal[0].da_opis
//print(self.opisTextView.contentSize.height)
            self.czasLabel.text = self.meal[0].da_czas + " " + "L_MIN".localized()
            self.wagaLabel.text = "\(self.meal[0].waga) " + "L_G".localized()
            self.waga = self.meal[0].waga //potrzebne do obsługi stolika
            self.kcalLabel.text = "\(self.meal[0].kcal) " + "L_KCAL".localized()
            self.kcal = self.meal[0].kcal //potrzebne do obsługi stolika
            
            
            if Shared.shared.uz_id! != "" {
                //ikona uwaga - alergeny
                if self.memory![0].c != "brak" { //czy zalogowany ustawił alergeny
                    self.uwagaImage.image = UIImage(named: "uwaga.jpg")
                }else{
                    self.uwagaImage.image = nil
                }
            }
            
            //== wyświetlenie danych na pasku wstawiania dań do stolika
            if (Shared.shared.uz_id != "")  && (self.resta != 0){//jeżeli zalogowany i wybrana resta
                self.plusButton.isHidden = false
                self.minusButton.isHidden = false
                self.iloscLabel.isHidden = false
                Shared.shared.na_stoliku = self.meal[0].na_stoliku
                self.iloscLabel.text = "\(self.meal[0].na_stoliku)"
                //self.iloscLabel.textColor = Shared.shared.malinaColor
                
            }
         
            Shared.shared.alergeny = self.meal[0].alergeny  //lista alergenów do pamieci
            
            //usunięcie wyświetlania buttonów wyboru dodatków wariantowych i dodatkowych
            //potrzebne przy zmianie wersji dania - nie wiem jak wykasować dodatki dodatkowe!!!
            self.btnWariant1.removeFromSuperview()
            self.btnWariant2.removeFromSuperview()
            
            Shared.shared.lista_wersji = self.meal[0].da_wersja_lista  //lista wersji do pamieci
            Shared.shared.lista_wariant1 = self.meal[0].do_wariant_lista1  //lista dod.wariant1 do pamieci
            Shared.shared.lista_wariant2 = self.meal[0].do_wariant_lista2  //lista dod.wariant2 do pamieci
            Shared.shared.wyborIdDodatkowe = []  //czyszczenie tablicy
            
            var offwar = 5  //uwzględnianie obecności wersji i dod. wariantowych przy wyświetlaniu dodatkowych

            //utworzenie wersji dania
            if self.meal[0].da_wersja_lista.count > 0 {
                offwar += 55
                //wersja wybrana z listy
                let wersja: String = self.meal[0].da_wersja_lista[Shared.shared.wyborIdWersja]
                //Shared.shared.wyborIdWersja = 0 //index pierwszego miejsca na liście = 0
                self.createButton0(text: wersja)
            }
            
            
            //==utworzenie dodatku wariantowego 1 - jeśli jest lista dod. wariantowych 1
            if self.meal[0].do_wariant_lista1.count > 0 {
                if self.meal[0].da_wersja_lista.count > 0 {
                    offwar += 45
                }else{
                    offwar += 55
                }
                if self.meal[0].do_wariant.count > 0  {  //jeżeli są dodatki ulubione
                    let wariant1: String = "+  " + self.meal[0].do_wariant[0]
                    Shared.shared.wyborIdWariant1 = self.meal[0].do_wariant_lista1_id.index(of: self.meal[0].do_wariant_id[0])//zapamiętaj index miejsca dodatku na liście (nie id dodatku)
                    self.createButton1(text: wariant1)
                }else{
                    let wariant1: String = "+  " + self.meal[0].do_wariant_lista1[0] //pierwszy z listy
                    Shared.shared.wyborIdWariant1 = 0 //index pierwszego miejsca na liście = 0
                    self.createButton1(text: wariant1)
                }
                 //print(Shared.shared.wyborIdWariant1)
            }
            //==utworzenie dodatku wariantowego 2 - jeśli jest
            if self.meal[0].do_wariant_lista2.count > 0 {
                offwar += 45
                if self.meal[0].do_wariant.count > 1  {  //jeżeli są dodatki ulubione
                    let wariant2: String = "+  " + self.meal[0].do_wariant[1]
                    Shared.shared.wyborIdWariant2 = self.meal[0].do_wariant_lista2_id.index(of: self.meal[0].do_wariant_id[1])//zapamiętaj index miejsca dodatku na liście (nie id dodatku)
                    self.createButton2(text: wariant2)
                }else{
                    let wariant2: String = "+  " + self.meal[0].do_wariant_lista2[0] //pierwszy z listy
                     Shared.shared.wyborIdWariant2 = 0 //index pierwszego miejsca na liście = 0
                    self.createButton2(text: wariant2)
                }
            }
           
            //==utworzenie listy dodatków dodatkowych
            var offdod = 0
            if self.meal[0].do_dodat.count > 0  {
                
                var tag = 0
                for dodatek in self.meal[0].do_dodat{
                    let box = BEMCheckBox(frame: CGRect(x: 23, y: 447 + offwar + offdod, width: 20, height: 20))
                    box.minimumTouchSize = CGSize(width: 600, height: 20)
                    box.boxType = BEMBoxType.square
                    box.animationDuration = 0.5
                    box.onAnimationType = BEMAnimationType.fill
                    box.offAnimationType = BEMAnimationType.fill
                    box.onFillColor = UIColor.red
                    box.onTintColor = UIColor.red
                    box.onCheckColor = UIColor.white
                    box.offFillColor = UIColor.white //żeby kasować kolor po przeładowaniu (warianty)
                    box.tag = tag
                    tag += 1
                    box.delegate = self
                    self.myScrollView.addSubview(box)
                    
                    //położenie checkboxa - zależne od pola tekstowego opisu
                    box.translatesAutoresizingMaskIntoConstraints = false
                    [
                        box.topAnchor.constraint(equalTo: self.opisTextView.bottomAnchor, constant: CGFloat(5 + offwar + offdod)),
                        box.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 23),
                        box.widthAnchor.constraint(equalToConstant: 20),
                        box.heightAnchor.constraint(equalToConstant: 20)
                        ].forEach{$0.isActive = true}
                    
                    let text = UILabel(frame: CGRect(x: 52, y: 438 + offwar + offdod, width: 350, height: 40))
                    text.font = UIFont(name: "Arial", size: 18)
                    text.textColor = UIColor.gray
                    text.text = dodatek
                    self.myScrollView.addSubview(text)
                    
                    //położenie opisu checkboxa - zależne od pola tekstowego opisu
                    text.translatesAutoresizingMaskIntoConstraints = false
                    [
                        text.topAnchor.constraint(equalTo: self.opisTextView.bottomAnchor, constant: CGFloat(-6 + offwar + offdod)),
                        text.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 52),
                        text.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60),
                        text.heightAnchor.constraint(equalToConstant: 40)
                        ].forEach{$0.isActive = true}
                    offdod += 40
                    //print(box.tag)
                }
            }

            //print("myScrollView.height=")
            //print(self.myScrollView.frame.size.height)

//wysokość całego widoku do przewijania - nie chce działać ograniczenie przewijania!!!!!!!
       /*     var contentRect = CGRect.zero
            for view in self.myScrollView.subviews{
                contentRect = contentRect.union(view.frame)
            }
            self.myScrollView.frame.size = contentRect.size
       */
//self.myScrollView.frame.size.height = CGFloat(0)
            if CGFloat(438 + offwar + offdod) > (self.view.frame.height) {
                 self.myScrollView.frame.size.height = CGFloat(433 + offwar + offdod)
            }else{
                self.myScrollView.frame.size.height = self.view.frame.height
            }
//print("myScrollView.height=")
//print(self.myScrollView.frame.size.height)
//self.myScrollView.frame.size.height = CGFloat(433 + offwar + offdod)

//print(self.view.frame.height)
//print("wysokość myScrollView")
//print(433 + offwar + offdod)
//print(self.myScrollView.frame.size.height)
            
            self.downloadJSON_resta{
                //print("json resta")
                Shared.shared.restauracje = self.meal_resta //zapamiętanie szczegółów wszystkich restauracji
                //print (self.meal_resta)
            }
            self.downloadJSON_sklad{
                Shared.shared.sklad = self.meal_sklad       //zapamietanie składników dania
            }
            self.downloadJSON_opinie{
                Shared.shared.opinie = self.meal_opinie     //zapamiętanie opinii o daniu
                
               //zapamiętanie opinii zalogowanego
                for moje in self.meal_opinie{
                    if moje.op_uz_id == Shared.shared.uz_id {
                        self.moje_meal_opinie.append(moje)
                    }
                }
                 Shared.shared.moje_opinie =  self.moje_meal_opinie
            }
        }
    }
    
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        let res = aktualizujStolik(akcja: "1") //dodanie dania
        if res == 1 {
            Shared.shared.na_stoliku = Shared.shared.na_stoliku + 1
            self.iloscLabel.text = "\(Shared.shared.na_stoliku!)"
            //print(Shared.shared.na_stoliku)
        }
    }
    
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        let res = aktualizujStolik(akcja: "2") //usunięcie dania
        if res == 1 {
            if Shared.shared.na_stoliku > 0{
                Shared.shared.na_stoliku = Shared.shared.na_stoliku - 1
                self.iloscLabel.text = "\(Shared.shared.na_stoliku!)"
            }
        }
    }
    
    //----------------------------------------------------------
    //aktualizacja stolika na serwerze
    //----------------------------------------------------------
    func aktualizujStolik(akcja: String)  -> Int  {
        //przygotowanie listy wybranych dodatków dodatkowych (zrobienie stringa z tabeli integerów)
        var wariant1 = ""
        var wariant2 = ""
        var dodatki: String = ""
        
        if meal[0].do_wariant_lista1_id.isEmpty {wariant1 = "0"}
        else {wariant1 =  self.meal[0].do_wariant_lista1_id[Shared.shared.wyborIdWariant1]}
        
        if meal[0].do_wariant_lista2_id.isEmpty {wariant2 = "0"}
        else {wariant2 =  self.meal[0].do_wariant_lista2_id[Shared.shared.wyborIdWariant2]}
        
        let ile = Shared.shared.wyborIdDodatkowe .count
        if ile > 0 {
            for indexDodatku in Shared.shared.wyborIdDodatkowe {
                dodatki += self.meal[0].do_dodat_id[indexDodatku] + ","
            }
            dodatki = String(dodatki.dropLast(1)) //usunięcie oststniego przecinka
        }else{dodatki = "0"}
        
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_na_stolik.php")
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["st_uz_id": Shared.shared.uz_id,
                          "st_re_id": String(resta),
                          "st_da_id": self.meal[0].da_id,
                          "st_dw1": wariant1,
                          "st_dw2": wariant2,
                          "st_dd": dodatki,
                          "st_cena": String(cena),
                          "st_waga": String(waga),
                          "st_kcal": String(kcal),
                          "st_akcja": akcja,] as [String: String]
        
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
                return
            }
            
            //konwertowanie danych odebranych z serwera
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                print ("json:====== \(String(describing: json!))")
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
    
    
    //=== tworzenie programowe buttona - wersja dania
    func createButton0(text: String){
        self.btnWersja.backgroundColor = .clear
        self.btnWersja.setTitleColor(UIColor.gray, for: .normal) //darkGray
        self.btnWersja.titleLabel?.font = UIFont(name: "Arial", size: 18)
        self.btnWersja.contentHorizontalAlignment = .left
        self.btnWersja.contentEdgeInsets.left = 10
        self.btnWersja.layer.cornerRadius = 10
        self.btnWersja.layer.borderWidth = 1.0
        self.btnWersja.layer.borderColor = UIColor.lightGray.cgColor

        self.btnWersja.setTitle(text, for: .normal)
        self.btnWersja.addTarget(self, action: #selector(self.showPopup0), for: .touchUpInside)

        self.myScrollView.addSubview(self.btnWersja) //utworzenie buttona na view scrollowanym
        
        //położenie buttona 0 - zależne od pola tekstowego opisu
        self.btnWersja.translatesAutoresizingMaskIntoConstraints = false
        [
            self.btnWersja.topAnchor.constraint(equalTo: self.opisTextView.bottomAnchor, constant: 5),
            self.btnWersja.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.btnWersja.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 40),
            self.btnWersja.heightAnchor.constraint(equalToConstant: 40)
            ].forEach{$0.isActive = true}
    }
    
    //=== tworzenie programowe buttona - dodatek wariantowy1
    func createButton1(text: String){
        self.btnWariant1.backgroundColor = .clear
        self.btnWariant1.setTitleColor(UIColor.gray, for: .normal) //darkGray
        self.btnWariant1.titleLabel?.font = UIFont(name: "Arial", size: 18)
        self.btnWariant1.contentHorizontalAlignment = .left
        self.btnWariant1.contentEdgeInsets.left = 10
        self.btnWariant1.layer.cornerRadius = 10
        self.btnWariant1.layer.borderWidth = 1.0
        self.btnWariant1.layer.borderColor = UIColor.lightGray.cgColor
        //let wariant1: String = "+  " + self.meal[0].do_wariant[0]
        self.btnWariant1.setTitle(text, for: .normal)
        self.btnWariant1.addTarget(self, action: #selector(self.showPopup1), for: .touchUpInside)
        //self.btnWariant1.frame =  CGRect(x: 20, y: 440, width: view.frame.width - 40, height: 40) //button wariant1
        self.myScrollView.addSubview(self.btnWariant1) //utworzenie buttona na view scrollowanym
        
        //położenie buttona 1 - zależne od pola tekstowego opisu
        var offwer = 0
        if self.meal[0].da_wersja_lista.count > 0 {offwer = 45} //jeżeli są wersje dania
        self.btnWariant1.translatesAutoresizingMaskIntoConstraints = false
        [
            self.btnWariant1.topAnchor.constraint(equalTo: self.opisTextView.bottomAnchor, constant: CGFloat(5 + offwer)),
            self.btnWariant1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.btnWariant1.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 40),
            self.btnWariant1.heightAnchor.constraint(equalToConstant: 40)
        ].forEach{$0.isActive = true}
    }

    //=== tworzenie programowe buttona - dodatek wariantowy2
    func createButton2(text: String){
        self.btnWariant2.backgroundColor = .clear
        self.btnWariant2.setTitleColor(UIColor.gray, for: .normal) //darkGray
        self.btnWariant2.titleLabel?.font = UIFont(name: "Arial", size: 18)
        self.btnWariant2.contentHorizontalAlignment = .left
        self.btnWariant2.contentEdgeInsets.left = 10
        self.btnWariant2.layer.cornerRadius = 10
        self.btnWariant2.layer.borderWidth = 1.0
        self.btnWariant2.layer.borderColor = UIColor.lightGray.cgColor
        //let wariant1: String = "+  " + self.meal[0].do_wariant[0]
        self.btnWariant2.setTitle(text, for: .normal)
        self.btnWariant2.addTarget(self, action: #selector(self.showPopup2), for: .touchUpInside)
        //self.btnWariant2.frame =  CGRect(x: 20, y: 485, width: view.frame.width - 40, height: 40) //button wariant2
        self.myScrollView.addSubview(self.btnWariant2) //utworzenie buttona na view scrollowanym
        
        //położenie buttona 2 - zależne od pola tekstowego opisu
        var offwer = 0
        if self.meal[0].da_wersja_lista.count > 0 {offwer = 45} //jeżeli są wersje dania
        self.btnWariant2.translatesAutoresizingMaskIntoConstraints = false
        [
            self.btnWariant2.topAnchor.constraint(equalTo: self.opisTextView.bottomAnchor, constant: CGFloat(50 + offwer)),
            self.btnWariant2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.btnWariant2.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 40),
            self.btnWariant2.heightAnchor.constraint(equalToConstant: 40)
            ].forEach{$0.isActive = true}

    }
    
    //===============================================
    //wyświetlenie okna popup - wybór wersji dania
    //===============================================
    @IBAction func showPopup0(_ sender: Any) {
        let popup0VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUp0ID") as! Pop0ViewController
        
        self.addChildViewController(popup0VC)
        popup0VC.view.frame = self.view.frame
        popup0VC.delegate = self  //1 utworzenie delegata w widoku z którego mają wrócić dane
        self.view.addSubview(popup0VC.view)
        popup0VC.didMove(toParentViewController: self)
    }
    
    //===============================================
    //wyświetlenie okna popup - wybór dodatku: wariantowy_1
    //===============================================
    @IBAction func showPopup1(_ sender: Any) {
        let popup1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUp1ID") as! Pop1ViewController
        
        self.addChildViewController(popup1VC)
        popup1VC.view.frame = self.view.frame
        popup1VC.delegate = self  //1 utworzenie delegata w widoku z którego mają wrócić dane
        self.view.addSubview(popup1VC.view)
        popup1VC.didMove(toParentViewController: self)
    }
    
    //===============================================
    //wyświetlenie okna popup - wybór dodatku: wariantowy_2
    //===============================================
    @IBAction func showPopup2(_ sender: Any) {
        let popup2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUp2ID") as! Pop2ViewController
        
        self.addChildViewController(popup2VC)
        popup2VC.view.frame = self.view.frame
        popup2VC.delegate = self  //1 utworzenie delegata w widoku z którego mają wrócić dane
        self.view.addSubview(popup2VC.view)
        popup2VC.didMove(toParentViewController: self)
    }
    
    //=========================================================
    //funkcja pobierająca JSONa ze szczegółami wybranego dania (id dania z tabeli 'memory')
    //=========================================================
    func downloadJSON(completed: @escaping () -> ()) {
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_danie1&danie=\(memory![0].a)&uz_id=\(Shared.shared.uz_id!)&rest=\(resta)&lang=\(Localize.currentLanguage())")

        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    self.meal = try JSONDecoder().decode([MealState].self, from: data!)                   
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print ("JSON Error meal \(error)")
                }
            }
        }.resume()
    }
   
    //=========================================================
    //funkcja pobierająca JSONa ze szczegółami restauracji (id dania z tabeli 'memory')
    //=========================================================
    func downloadJSON_resta(completed: @escaping () -> ()) {
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_danie_resta&danie=\(memory![0].a)&uz=&lang=\(Localize.currentLanguage())")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    self.meal_resta = try JSONDecoder().decode([MealResta].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print ("JSON Error meal_resta")
                }
            }
        }.resume()
    }

    //=========================================================
    //funkcja pobierająca JSONa ze składnikami dania (id dania z tabeli 'memory')
    //=========================================================
    func downloadJSON_sklad(completed: @escaping () -> ()) {
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_danie_sklad&danie=\(memory![0].a)&uz_id=\(Shared.shared.uz_id!)&lang=\(Localize.currentLanguage())")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    self.meal_sklad = try JSONDecoder().decode([MealSklad].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print ("JSON Error meal_sklad")
                }
            }
            }.resume()
    }
    //=========================================================
    //funkcja pobierająca JSONa z opiniami o daniu (id dania z tabeli 'memory')
    //=========================================================
    func downloadJSON_opinie(completed: @escaping () -> ()) {
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_danie_opinie&danie=\(memory![0].a)&uz=&lang=\(Localize.currentLanguage())")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    self.meal_opinie = try JSONDecoder().decode([MealOpinie].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                        //if self.meal_opinie.isEmpty {print(self.meal_opinie)}
                    }
                }catch {
                    print ("JSON Error - brak opinii")
                }
            }
        }.resume()
    }
    
    func przelicz(){
        waga = 0
        kcal = 0
        cena = 0.00
        
        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
        
        waga += Int(self.meal[0].da_waga_podst)!            //waga podstawowa
        kcal += Int(self.meal[0].da_kcal_podst)!            //kcal podstawowe
        cena += Float(self.meal[0].cena_podst)!             //cena podstawowa
        if self.meal[0].do_wariant_lista1.count > 0{        //jeżeli są dodatki wariant1
            waga += Int(self.meal[0].do_wariant_lista1_waga[Shared.shared.wyborIdWariant1])! //+ wariant1
            kcal += Int(self.meal[0].do_wariant_lista1_kcal[Shared.shared.wyborIdWariant1])! //+ wariant1
            cena += Float(self.meal[0].do_wariant_lista1_cena[Shared.shared.wyborIdWariant1])! //+ wariant1
        }
        if self.meal[0].do_wariant_lista2.count > 0{        //jeżeli są dodatki wariant2
            waga += Int(self.meal[0].do_wariant_lista2_waga[Shared.shared.wyborIdWariant2])! //+ wariant2
            kcal += Int(self.meal[0].do_wariant_lista2_kcal[Shared.shared.wyborIdWariant2])! //+ wariant2
            cena += Float(self.meal[0].do_wariant_lista2_cena[Shared.shared.wyborIdWariant2])! //+ wariant2
        }
        
        for indexDodatku in Shared.shared.wyborIdDodatkowe {
            waga += Int(self.meal[0].do_dodat_waga[indexDodatku])!
            kcal += Int(self.meal[0].do_dodat_kcal[indexDodatku])!
            cena += Float(self.meal[0].do_dodat_cena[indexDodatku])!
        }
        
        self.wagaLabel.text = "\(waga) " + "L_G".localized()
        self.kcalLabel.text = "\(kcal) " + "L_KCAL".localized()
        //self.cenaLabel.text = (String(format: "%.2f",(cena)) + " " + "L_PLN".localized()).replacingOccurrences(of: ".", with: ",")
        //formatowanie i wyświetlanie ceny
        let numCena = formatter1.string(from: NSNumber(value: Float(cena)))
        self.cenaLabel.text = "\(numCena! ) " + "L_PLN".localized()
        
        //print(waga)
    }
    
    
    func didTap(_ checkBox: BEMCheckBox) { //tag = indeks w liście dodatków dodatkowych
        if checkBox.on {
            Shared.shared.wyborIdDodatkowe.append(checkBox.tag) //dodanie taga do tablicy tagów
            przelicz()
        }else {
            let miejsceTagaWTablicy = Shared.shared.wyborIdDodatkowe.index(of: checkBox.tag) //index taga
            Shared.shared.wyborIdDodatkowe.remove(at: miejsceTagaWTablicy!) //usunięcie taga
            przelicz()
        }
       //print (Shared.shared.wyborIdDodatkowe)
    }
    
    //komunikat "Brak Internetu"
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }


}




//===========================================================
//4 rozszerzenie klasy pobierajacej dane o protokół delegata
//implementacja protokołu delegata
//dane z delegata w Pop1ViewController przekazane do klasy pobierajacej dane czyli Tab1ViewController
//np. wariantLabel.text = value
//===========================================================

extension Tab1ViewController: PopupDelegate0{
    func popupValueSelected0(value: Int) {
        //btnWersja.setTitle("+  " + self.meal[0].da_wersja_lista[value], for: .normal)
        Shared.shared.wyborIdWersja = value  //index listy(!) wybranej wersji
        //print(Shared.shared.wyborIdWersja)
        //print(self.meal[0].da_id_lista_wer[value])  //id dania wybranej wersji
        
        // id aktualnie wyświetlanego dania: (memory![0].a)
        if self.meal[0].da_id_lista_wer[value] != "0"{
            var danie = [Mealdb]() //danie z bazy lokalnej
            danie = StephencelisDB.instance.getDanie(id: self.meal[0].da_id_lista_wer[value]) //pobranie dania z bazy lokalnej
            //print("id dania = \(danie[0].daid)")
            //print(danie)
            if danie.isEmpty{
                print("pusto")
            }else{
                //update id wybranego dania w bazie lokalnej - nowe id zapisane do tabeli 'memory'
                _ = StephencelisDB.instance.updateMemory(mem: "mem_danie", a: danie[0].daid, b: danie[0].foto, c: danie[0].alergeny, d: danie[0].nazwa, e: "", f: "")
                
                //sprawdzenie dostępu do Internetu
                self.reachability = Reachability.init()
                if((self.reachability!.connection) != .none){ //jeżeli jest Internet
                    self.viewDidLoad() //przeładowanie Tab1ViewController bo nowe danie do wyświetlenia
                }else{ //jeżeli nie ma Internetu
                    displayAlert()
                }
            }
        }
    }
}

extension Tab1ViewController: PopupDelegate1{
    func popupValueSelected1(value: Int) {
        btnWariant1.setTitle("+  " + self.meal[0].do_wariant_lista1[value], for: .normal)
        Shared.shared.wyborIdWariant1 = value  //index listy(!) wybranego dodatku wariantowego 1
        //print(Shared.shared.wyborIdWariant1)
        przelicz()
    }
}

extension Tab1ViewController: PopupDelegate2{
    func popupValueSelected2(value: Int) {
        btnWariant2.setTitle("+  " + self.meal[0].do_wariant_lista2[value], for: .normal)
        Shared.shared.wyborIdWariant2 = value  //index listy(!) wybranego dodatku wariantowego 2
        przelicz()
    }
}
