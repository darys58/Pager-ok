//
//  RezerwacjaViewController.swift
//  Pager
//
//  Created by darys on 14.06.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Localize_Swift

class RezerwacjaViewController: UIViewController, BEMCheckBoxDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var rezerwacjaView: UIView!
    @IBOutlet weak var dataLabel: UILabel!    
    @IBOutlet weak var miejscLabel: UILabel!
    @IBOutlet weak var pobytLabel: UILabel!
    @IBOutlet weak var imieLabel: UILabel!
    @IBOutlet weak var nazwiskoLabel: UILabel!
    @IBOutlet weak var telefonLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var uwagiLabel: UILabel!
    
    @IBOutlet weak var dataField: UITextField!
    @IBOutlet weak var godzinaField: UITextField!
    @IBOutlet weak var miejscField: UITextField!
    @IBOutlet weak var pobytField: UITextField!
    @IBOutlet weak var imieField: UITextField!
    @IBOutlet weak var nazwiskoField: UITextField!
    @IBOutlet weak var telefonField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var uwagiField: UITextField!

    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    let pickerData = UIDatePicker()
    var pickerView = UIPickerView()
    var pickerViewMogeJesc = UIPickerView()
    let godziny = ["12:00", "12:15","12:30","12:45","13:00", "13:15","13:30","13:45","14:00", "14:15","14:30","14:45","15:00", "15:15","15:30","15:45","16:00", "16:15","16:30","16:45","17:00", "17:15","17:30","17:45","18:00", "18:15","18:30","18:45","19:00", "19:15","19:30","19:45","20:00", "20:15","20:30","20:45","21:00", "21:15","21:30","21:45"]
    let godzinyMogeJesc = [ "12:15","12:30","12:45","13:00", "13:15","13:30","13:45","14:00", "14:15","14:30","14:45","15:00", "15:15","15:30","15:45","16:00", "16:15","16:30","16:45","17:00", "17:15","17:30","17:45","18:00", "18:15","18:30","18:45","19:00", "19:15","19:30","19:45","20:00", "20:15","20:30","20:45","21:00"]
    var offset = 0  //przesunięcie "pozycji" przycisków jeżeli jest moje menu
    var offmoge = 0 //miejsce na ustawianie opcji "Moge jeść"
    var czasMogeJesc: UITextField?
    var zamZam = [Zamowienie]()  //tablica zamówień
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //domyślne ustawienie checkboxa akceptacji regulaminu
        Shared.shared.akceptuje = "nie"
        
        //tytuł ekranu
        let titlelabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel1
        titlelabel1.text = "L_REZERWACJA_STOL".localized()
        titlelabel1.textAlignment = .center
        
        //data rezerwacji
        createDatePicker()
        
        //godzina dostawy
        pickerView.delegate = self
        pickerView.dataSource = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedGodz))
        toolbar.setItems([done], animated: false)
        godzinaField.inputAccessoryView = toolbar
        godzinaField.inputView = pickerView
        godzinaField.placeholder = "L_GODZ".localized()
    
        //formularz
        miejscLabel.text = "L_MIEJSC".localized()
        miejscField.placeholder = "L_MIEJSC_HOLDER".localized()
        pobytLabel.text = "L_POBYT".localized()
        pobytField.placeholder = "L_POBYT_HOLDER".localized()
        imieLabel.text = "L_IMIE".localized()
        imieField.placeholder = "L_IMIE_HOLDER".localized()
        nazwiskoLabel.text = "L_NAZWISKO".localized()
        nazwiskoField.placeholder = "L_NAZWISKO_HOLDER".localized()
        telefonLabel.text = "L_TELEFON".localized()
        telefonField.placeholder = "L_TELEFON_HOLDER".localized()
        emailLabel.text = "L_EMAIL".localized()
        emailField.placeholder = "L_EMAIL_HOLDER".localized()
        uwagiLabel.text = "L_UWAGI".localized()
        uwagiField.placeholder = "L_UWAGI_HOLDER".localized()
    
        dataField.text = Shared.shared.data
        godzinaField.text = Shared.shared.godzina
        miejscField.text = Shared.shared.miejsc
        pobytField.text = Shared.shared.pobyt
        imieField.text = Shared.shared.imie
        nazwiskoField.text = Shared.shared.nazwisko
        telefonField.text = Shared.shared.telefon
        emailField.text = Shared.shared.email
        czasMogeJesc?.text = Shared.shared.czasMogeJesc!
        
        // pozycja y dla checkboxa dołączania menu
        let pozycja = 330

        if Shared.shared.stolik[0].st_ile != "0" { //możliwość dołączania dań jeżeli są
            
            //checkbox "Dołacz moje menu"
            let box = BEMCheckBox(frame: CGRect(x: 40, y: 330, width: 20, height: 20))
            box.minimumTouchSize = CGSize(width: 600, height: 20)
            box.boxType = BEMBoxType.square
            box.animationDuration = 0.5
            box.onAnimationType = BEMAnimationType.fill
            box.offAnimationType = BEMAnimationType.fill
            box.onFillColor = UIColor.red
            box.onTintColor = UIColor.red
            box.onCheckColor = UIColor.white
            box.tag = 1 //tag = 1 oznacza czeckbox dołączaia menu
            box.delegate = self
            if Shared.shared.dolaczMenu == "1" {box.on = true}
            self.rezerwacjaView.addSubview(box)
            
            //label "Dołącz moje menu"
            let text = UILabel(frame: CGRect(x: 70, y: 325, width: 350, height: 30))
            text.font = UIFont(name: "Arial", size: 14)
            text.textColor = UIColor.gray
            text.text = "L_DOLACZ_MENU".localized()
            self.rezerwacjaView.addSubview(text)
            offset = 35
 //------------
            
            if Shared.shared.dolaczMenu == "1" { //jeżeli menu ma być dołaczone
                if Shared.shared.mogeJesc == "1" {
                    //opcja "mogę jeść" - label
                    let mogeLabel = UILabel(frame: CGRect(x: 10, y: 360, width: 150, height: 30))
                    mogeLabel.text = "L_MOGE_JESC".localized()
                    mogeLabel.textColor = UIColor.darkGray
                    mogeLabel.font = UIFont.systemFont(ofSize: 14)
                    mogeLabel.textAlignment = .right
                    self.rezerwacjaView.addSubview(mogeLabel)
                    
                    //godzina
                    czasMogeJesc = UITextField(frame: CGRect(x: 180, y: 360, width: 95, height: 30))
                    czasMogeJesc?.placeholder = "L_GODZ".localized()
                    czasMogeJesc?.borderStyle = .roundedRect
                    czasMogeJesc?.font = UIFont.systemFont(ofSize: 14)
                    czasMogeJesc?.delegate = self
                    if Shared.shared.czasMogeJesc != nil {
                        czasMogeJesc?.text = (Shared.shared.czasMogeJesc!)
                    }
                
                
                    //godzina w opcji "Mogę jeść"
                    pickerViewMogeJesc.delegate = self
                    pickerViewMogeJesc.dataSource = self
                    let toolbarMJ = UIToolbar()
                    toolbarMJ.sizeToFit()
                    let done1 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedGodz))
                    toolbarMJ.setItems([done1], animated: false)
                    czasMogeJesc?.inputAccessoryView = toolbarMJ
                    czasMogeJesc?.inputView = pickerViewMogeJesc
                    
                    self.rezerwacjaView.addSubview(czasMogeJesc!)
                }else{offmoge = -40}
                
                //wyświetlwnie dań stolika
                var i = 0
                for dan in Shared.shared.stolik{
                    let linia = UIView(frame: CGRect(x: 16, y: 410 + offmoge + (30 * i), width: Int(self.view.frame.size.width - 32), height: 1))
                    linia.backgroundColor = UIColor.lightGray
                    self.rezerwacjaView.addSubview(linia)
                    //ilość i nazwa dania
                    let danie = UILabel(frame: CGRect(x: 20, y: 410 + offmoge + (30 * i), width: Int(self.view.frame.size.width - 120), height: 30))
                    danie.text = dan.st_ile + " x " + dan.da_nazwa
                    danie.textColor = UIColor.darkGray
                    danie.font = UIFont.systemFont(ofSize: 14)
                    //danie.lineBreakMode = .byWordWrapping
                    //danie.numberOfLines = 3
                    self.rezerwacjaView.addSubview(danie)
                    //cena dania
                    let cena = UILabel(frame: CGRect(x: Int(self.view.frame.size.width - 116), y: 410 + offmoge + (30 * i), width: 100, height: 30))
                    
                    //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
                    let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                    formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                    formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                    //let cena_temp = dan.st_cena
                    let numCena = formatter1.string(from: NSNumber(value: Float(dan.st_cena)!))

                    cena.text = numCena! + " " + "L_PLN".localized()
                    cena.textColor = UIColor.darkGray
                    cena.font = UIFont.systemFont(ofSize: 14)
                    cena.textAlignment = .right
                    self.rezerwacjaView.addSubview(cena)
                    i += 1
                }
                
                let linia = UIView(frame: CGRect(x: 16, y: 410 + offmoge + (30 * i), width: Int(self.view.frame.size.width - 32), height: 1))
                linia.backgroundColor = UIColor.lightGray
                self.rezerwacjaView.addSubview(linia)
                
                //RAZEM
                let razem = UILabel(frame: CGRect(x: 20, y: 410 + offmoge + (30 * i), width: Int(self.view.frame.size.width - 150), height: 30))
                razem.text = "L_RAZEM".localized()
                razem.textColor = UIColor.darkGray
                razem.font = UIFont.systemFont(ofSize: 14)
                razem.textAlignment = .right
                self.rezerwacjaView.addSubview(razem)
                //cena razem
                let cena = UILabel(frame: CGRect(x: Int(self.view.frame.size.width - 116), y: 410 + offmoge + (30 * i), width: 100, height: 30))
                
                //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
                let formatter1 = NumberFormatter() //deklaracja obiektu formatera
                formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
                formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
                let numWartosc = formatter1.string(from: NSNumber(value: Float(Shared.shared.cenaRazem)!))
                
                cena.text = numWartosc! + " " + "L_PLN".localized()
                cena.textColor = UIColor.darkGray
                cena.font = UIFont.systemFont(ofSize: 14)
                cena.textAlignment = .right
                self.rezerwacjaView.addSubview(cena)
                let liniaEnd = UIView(frame: CGRect(x: 16, y: 410 + offmoge + (30 * i) + 30, width: Int(self.view.frame.size.width - 32), height: 1))
                liniaEnd.backgroundColor = UIColor.lightGray
                self.rezerwacjaView.addSubview(liniaEnd)
                
                offset = 30 + (30 * Shared.shared.stolik.count) + 100
            }
        }else{offset = 0}
//---
        //checkbox akceptacji regulaminu
        let box = BEMCheckBox(frame: CGRect(x: 40, y: pozycja + offmoge + offset + 5, width: 20, height: 20))
        box.minimumTouchSize = CGSize(width: 600, height: 20)
        box.boxType = BEMBoxType.square
        box.animationDuration = 0.5
        box.onAnimationType = BEMAnimationType.fill
        box.offAnimationType = BEMAnimationType.fill
        box.onFillColor = UIColor.red
        box.onTintColor = UIColor.red
        box.onCheckColor = UIColor.white
        box.tag = 2  //tag = 2 oznacza checkbox akceptacji regulaminu
        box.delegate = self
        self.rezerwacjaView.addSubview(box)
        
        let text = UILabel(frame: CGRect(x: 70, y: pozycja + offmoge + offset, width: 350, height: 30))
        text.font = UIFont(name: "Arial", size: 14)
        text.textColor = UIColor.gray
        text.text = "L_AKCEPTUJE_REGULAMIN".localized()
        self.rezerwacjaView.addSubview(text)
  
        
        //przycisk "Regulamin"
        let regulaminButton = UIButton.init(type: .system)
        regulaminButton.frame = CGRect(x: 10, y: pozycja + offmoge + offset + 50, width: Int(self.view.frame.size.width/2 - 15), height: 40)
        regulaminButton.setTitle("L_REGULAMIN".localized(), for: .normal)
        regulaminButton.titleLabel?.textColor = UIColor.white
        regulaminButton.tintColor = UIColor.white
        regulaminButton.layer.cornerRadius = 5.0
        regulaminButton.backgroundColor = UIColor.gray
        regulaminButton.addTarget(self, action: #selector(buttonRegulaminRezerwacjiClic(_ :)), for: .touchUpInside)
        self.rezerwacjaView.addSubview(regulaminButton)
        
        //przycisk "rezygnuje"
        let rezygnujeButton = UIButton.init(type: .system)
        rezygnujeButton.frame = CGRect(x: Int(self.view.frame.size.width/2 + 5), y: pozycja + offmoge + offset + 50, width: Int(self.view.frame.size.width/2 - 15), height: 40)
        rezygnujeButton.setTitle("L_REZYGNUJE".localized(), for: .normal)
        rezygnujeButton.titleLabel?.textColor = UIColor.white
        rezygnujeButton.tintColor = UIColor.white
        rezygnujeButton.layer.cornerRadius = 5.0
        rezygnujeButton.backgroundColor = UIColor.gray
        rezygnujeButton.addTarget(self, action: #selector(buttonRezygnujeClic(_ :)), for: .touchUpInside)
        self.rezerwacjaView.addSubview(rezygnujeButton)
        
        //przycisk "zamawiam"
        let dostawaButton = UIButton.init(type: .system)
        dostawaButton.frame = CGRect(x: 10, y: pozycja + offmoge + offset + 100, width: Int(self.view.frame.size.width - 20), height: 40)
        dostawaButton.setTitle("L_ZAMAWIAM".localized(), for: .normal)
        dostawaButton.titleLabel?.textColor = UIColor.white
        dostawaButton.tintColor = UIColor.white
        dostawaButton.layer.cornerRadius = 5.0
        dostawaButton.backgroundColor = Shared.shared.malinaColor
        dostawaButton.addTarget(self, action: #selector(buttonZamawiamClic(_ :)), for: .touchUpInside)
        self.rezerwacjaView.addSubview(dostawaButton)
    }
//-------------------------------
    
    @objc func buttonRegulaminRezerwacjiClic(_ : UIButton){
        performSegue(withIdentifier: "sbRegulaminRezerwacji", sender: self) //przejście
    }
    
    @objc func buttonRezygnujeClic(_ : UIButton){
        _ = navigationController?.popViewController(animated: true)//powrót do poprzedniego view
    }
    
    @objc func buttonZamawiamClic(_ : UIButton){
        //Odczytanie pól tekstowych i zapisanie do pamięci podręcznej
        
        Shared.shared.data = dataField.text
        Shared.shared.godzina = godzinaField.text
        Shared.shared.miejsc = miejscField.text
        Shared.shared.pobyt =  pobytField.text
        
        Shared.shared.imie = imieField.text
        Shared.shared.nazwisko = nazwiskoField.text
        Shared.shared.telefon =  telefonField.text
        Shared.shared.email = emailField.text
        if ((czasMogeJesc?.isEnabled = true) != nil) {
            Shared.shared.czasMogeJesc = (czasMogeJesc?.text!)!
        }
        
        if (Shared.shared.data?.isEmpty)! || (Shared.shared.godzina?.isEmpty)! || (Shared.shared.miejsc?.isEmpty)! || (Shared.shared.pobyt?.isEmpty)! || (Shared.shared.imie?.isEmpty)! || (Shared.shared.nazwisko?.isEmpty)! || (Shared.shared.telefon?.isEmpty)! || (Shared.shared.email?.isEmpty)!{
            
            displayMessageForm(userMessage: "L_WPROWADZ_DANE".localized())
            return
        }
       
        //sprawdzenie akceptacji regulaminu
        if Shared.shared.akceptuje == "nie"{
            displayMessageForm(userMessage: "L_AKCEPTUJ".localized())
            return
        }
        
        //utworzenie Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        //myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        var czasMoge = "0.00"
        if Shared.shared.czasMogeJesc != nil{
            czasMoge = Shared.shared.czasMogeJesc
        }
            
        
        //send HTTP Request to Dostawa
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_rezerwacja.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = [
            "za_uz_id": Shared.shared.uz_id,
            "za_re_id": location![0].e,
            "za_typ": "3",                     //3 - rezerwacja stolika
            "za_data": Shared.shared.data,
            "za_godz": Shared.shared.godzina,
            "za_czas": Shared.shared.pobyt,
            "za_miejsc": Shared.shared.miejsc,
            "za_imie": Shared.shared.imie,
            "za_nazwisko": Shared.shared.nazwisko,
            "za_telefon": Shared.shared.telefon,
            "za_email": Shared.shared.email,
            "za_uwagi": uwagiField.text!,
            "za_menu": Shared.shared.dolaczMenu,
            "za_moge": czasMoge,
            "za_lang": Shared.shared.lang,] as! [String: String]
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
                self.displayMessage(userMessage: "L_BLAD_WYSLANIE_ZAM".localized())
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
                        self.displayMessageForm(userMessage: "L_ZAMOWIENIE_NIE".localized())
                        return
                    }else{
                        self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                        self.displayMessage(userMessage: "L_ZAMOWIENIE_OK_ALE".localized())
                        return
                    }
                }else{ //jeżeli wyłano poprawnie meil do restauracji
                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                    self.displayMessage(userMessage: "L_ZAMOWIENIE_OK".localized())
                }
            } catch{
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessageForm(userMessage: "L_ZAMOWIENIE_NIE".localized())
                print(error)
            }
        }
        
        task.resume()
    }
    
  
    
    //utworzenie datepickera
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        dataField.inputAccessoryView = toolbar
        dataField.inputView = pickerData
        //typ pickera
        pickerData.datePickerMode = .date
    }
    
    //obsługa przycisku done na toolbarze daty
    @objc func donePressed(){
        //format date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        //formatter.dateStyle = .short
        //formatter.timeStyle = .none
        let dateString = formatter.string(from: pickerData.date)
        dataField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    //obsługa przycisku done na toolbarze godziny (zmienić!!! na Gotowe i Anuluj)
    @objc func donePressedGodz(){
        self.view.endEditing(true)
    }
    
    //obsłuda pickerów z godzinami
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1}
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewMogeJesc{
            return godzinyMogeJesc.count
        }else{
            return godziny.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewMogeJesc{
            return godzinyMogeJesc[row]
        }else{
            return godziny[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewMogeJesc{
            czasMogeJesc?.text = godzinyMogeJesc[row]
        }else{
            godzinaField.text = godziny[row]
        }
        //godzinaField.resignFirstResponder()
    }
    
 
    
    //-------------------------------------
    //obsługa checkboxa "Dołacz moje menu"
    //-------------------------------------
    func didTap(_ checkBox: BEMCheckBox) { //tag = indeks checkboxa
        
        if checkBox.tag == 1 { //jeżeli naciśnięto checkbox "dołącz menu"
            if checkBox.on {
                print(checkBox.tag)
                Shared.shared.dolaczMenu = "1" //ustawienie że zaznaczono dołączanie menu
                
                //Odczytanie pól tekstowych i zapisanie do pamięci podręcznej
                Shared.shared.data = dataField.text
                Shared.shared.godzina = godzinaField.text
                Shared.shared.miejsc = miejscField.text
                Shared.shared.pobyt =  pobytField.text
                
                Shared.shared.imie = imieField.text
                Shared.shared.nazwisko = nazwiskoField.text
                Shared.shared.telefon =  telefonField.text
                Shared.shared.email = emailField.text
                if ((czasMogeJesc?.isEnabled = true) != nil) { //jeżeli ustawiony czasMogeJesc
                    Shared.shared.czasMogeJesc = (czasMogeJesc?.text!)!
                }
                
                //powrót do stolika bo nie wiem jak przeładowac widok
                _ = navigationController?.popViewController(animated: true)//powrót do poprzedniego view (!!! a potrzebne tylko przeładowanie vidoku!!!???)
              
            }else{
                Shared.shared.dolaczMenu = "0"
                
                //Odczytanie pól tekstowych i zapisanie do pamięci podręcznej
                Shared.shared.data = dataField.text
                Shared.shared.godzina = godzinaField.text
                Shared.shared.miejsc = miejscField.text
                Shared.shared.pobyt =  pobytField.text
                
                Shared.shared.imie = imieField.text
                Shared.shared.nazwisko = nazwiskoField.text
                Shared.shared.telefon =  telefonField.text
                Shared.shared.email = emailField.text
                if ((czasMogeJesc?.isEnabled = true) != nil) {
                    Shared.shared.czasMogeJesc = nil //kasowanie czasMogeJesc
                }
                _ = navigationController?.popViewController(animated: true)//powrót do poprzedniego view (!!! tylko przeładować widok ???)
            }
        }
        
        if checkBox.tag == 2 { //jeżeli naciśnięto checkbox "akceptuj regulamin"
            if checkBox.on {
                Shared.shared.akceptuje = "tak"
                print("tak")
            }else {
                Shared.shared.akceptuje = "nie"
                print("nie")
            }
        }
        
        
    }

    //komunikaty z poprawności formularza
    func displayMessageForm(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "L_KOMUNIKAT".localized(), message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //komunikaty z wysyłki zamówienia
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "L_KOMUNIKAT".localized(), message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                
                DispatchQueue.main.async {
                    //pobranie zamówień [Zamowienie] - bo zmieniła sie ilość zamówień
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
    
    //usuwanie klawiatury z ekranu po naciśnięciu "Return" (działa przez delegata textField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
