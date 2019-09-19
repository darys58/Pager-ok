//
//  DostawaViewController.swift
//  Pager
//
//  Created by darys on 08.06.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import DLRadioButton
import Localize_Swift

class DostawaViewController: UIViewController, BEMCheckBoxDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var dostawaView: UIView!
    @IBOutlet weak var kosztMenuLabel: UILabel!
    @IBOutlet weak var kosztDostawyLabel: UILabel!
    @IBOutlet weak var kosztCalkowityLabel: UILabel!
    @IBOutlet weak var cenaMenuLabel: UILabel!
    @IBOutlet weak var cenaDostawyLabel: UILabel!
    @IBOutlet weak var cenaCalkowitaLabel: UILabel!
    
    @IBOutlet weak var miejsceLabel: UILabel!
    @IBOutlet weak var zamawiajacyLabel: UILabel!
    @IBOutlet weak var informacjeLabel: UILabel!
    @IBOutlet weak var zaplataLabel: UILabel!
   
    @IBOutlet weak var strefaButton: UIButton!
    @IBOutlet weak var adresLabel: UILabel!
    @IBOutlet weak var adresField: UITextField!
    @IBOutlet weak var numerLabel: UILabel!
    @IBOutlet weak var numerField: UITextField!
    @IBOutlet weak var kodLabel: UILabel!
    @IBOutlet weak var kodField: UITextField!
    @IBOutlet weak var miastoLabel: UILabel!
    @IBOutlet weak var miastoField: UITextField!
    @IBOutlet weak var imieLabel: UILabel!
    @IBOutlet weak var imieField: UITextField!
    @IBOutlet weak var nazwiskoLabel: UILabel!
    @IBOutlet weak var nazwiskoField: UITextField!
    @IBOutlet weak var telefonLabel: UILabel!
    @IBOutlet weak var telefonField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var dostawaLabel: UILabel!
    @IBOutlet weak var czasField: UITextField!
    @IBOutlet weak var uwagiLabel: UILabel!
    @IBOutlet weak var uwagiField: UITextField!
    
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var pickerView = UIPickerView()
    var czasy: [String] = ["L_JAK_NAJSZYBCIEJ".localized()]
    //let czasy = ["L_JAK_NAJSZYBCIEJ".localized(), "12:00", "12:15","12:30","12:45","13:00", "13:15","13:30","13:45","14:00", "14:15","14:30","14:45","15:00", "15:15","15:30","15:45","16:00", "16:15","16:30","16:45","17:00", "17:15","17:30","17:45","18:00", "18:15","18:30","18:45","19:00", "19:15","19:30","19:45","20:00", "20:15","20:30","20:45","21:00", "21:15","21:30","21:45",]
    var zamZam = [Zamowienie]()  //tablica zamówień
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //domyślne ustawienie checkboxa akceptacji regulaminu
        Shared.shared.akceptuje = "nie"

        //tytuł ekranu
        let titlelabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel1
        titlelabel1.text = "L_DOSTAWA_Z_REST".localized()
        titlelabel1.textAlignment = .center
        
        //radiobatony
        let frame = CGRect(x: 30, y: 20, width: 160, height: 25)
        let firstRadioButton = createRadioButton(frame: frame, title: "L_DOSTAWA".localized(), index: 0)
      
        
        //other buttons
        let opcje = ["L_ODBIOR_WLASNY".localized()];

        var i = 1;
        var otherButtons : [DLRadioButton] = [];
        for opcja in opcje {
            let frame = CGRect(x: view.frame.width/2, y: 20, width: 160, height: 25);
            let radioButton = createRadioButton(frame: frame, title: opcja, index: i);
            otherButtons.append(radioButton);
            i += 1;
        }
        firstRadioButton.otherButtons = otherButtons;
 
        if Shared.shared.dostawa == nil || Shared.shared.dostawa == 0 { firstRadioButton.isSelected = true} //domyślnie ustawiona dostawa
  
        //tabelka kosztów
        kosztMenuLabel.text = "L_KOSZT_MENU".localized()
        kosztDostawyLabel.text = "L_KOSZT_DOSTAWY".localized()
        kosztCalkowityLabel.text = "L_KOSZT_CALKOWITY".localized()
        
        //let cenaRazemFloat = Shared.shared.cenaRazem.replacingOccurrences(of: ",", with: ".")
        //let kosztOpakowanFloat = Shared.shared.kosztOpakowan.replacingOccurrences(of: ",", with: ".")
        //let cenaMenuRazemString = String(cenaMenuOpakowania)
        //let cenaMenuRazem = cenaMenuRazemString.replacingOccurrences(of: ".", with: ",")
        
        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
        
        //do ceny menu doliczana jest cena opakowań
        let cenaMenuOpakowania = Float(Shared.shared.cenaRazem)! + Float(Shared.shared.kosztOpakowan)!
        let numMenu = formatter1.string(from: NSNumber(value: cenaMenuOpakowania))
        cenaMenuLabel.text = "\(numMenu! ) " + "L_PLN".localized()//cena menu + opakowania
     
        //konfiguracja przycisku wybory stref dostawy
        strefaButton.backgroundColor = .clear
        //strefaButton.setTitleColor(UIColor.gray, for: .normal) //darkGray
        //strefaButton.titleLabel?.font = UIFont(name: "Arial", size: 15)
        strefaButton.contentHorizontalAlignment = .left
        strefaButton.contentEdgeInsets.left = 10
        strefaButton.layer.cornerRadius = 5
        strefaButton.layer.borderWidth = 0.5
        strefaButton.layer.borderColor = UIColor.lightGray.cgColor
        strefaButton.setTitle("L_STREFA".localized() + " " + String(Shared.shared.strefa + 1), for: .normal)
        strefaButton.addTarget(self, action: #selector(self.showPopup), for: .touchUpInside)

        //tutaj bo jak "odbiór własny" to placeholdery trzeba zastąpić "-----"
       
        adresLabel.text = "L_ADRES".localized()
        adresField.placeholder = "L_ADRES_HOLDER".localized()
        numerLabel.text = "L_NUMER".localized()
        numerField.placeholder = "L_NUMER_HOLDER".localized()
        kodLabel.text = "L_KOD".localized()
        kodField.placeholder = "L_KOD_HOLDER".localized()
        miastoLabel.text = "L_MIASTO".localized()
        miastoField.placeholder = "L_MIASTO_HOLDER".localized()
        adresField.text = Shared.shared.adres
        numerField.text = Shared.shared.numer
        kodField.text = Shared.shared.kod
        miastoField.text = Shared.shared.miasto
        
        //obliczenie kosztów dostawy
        if((Float(Shared.shared.cenaRazem)!) > (Float(Shared.shared.strefy[Shared.shared.strefa].str_wart_max))!){
            Shared.shared.koszt = Shared.shared.strefy[Shared.shared.strefa].str_koszt_bonus
        }else{
            Shared.shared.koszt = Shared.shared.strefy[Shared.shared.strefa].str_koszt
        }

        
        //koszty dostawy wyliczony jest w Shared.shared.koszt
        var dostarczenie = Shared.shared.koszt!
        if Shared.shared.dostawa == 1 { //jeżeli odbiór własny
            dostarczenie = "0.00"
            strefaButton.isEnabled = false
            strefaButton.setTitleColor(UIColor.lightGray, for: .normal) //darkGray
            strefaButton.backgroundColor = Shared.shared.mojSzary
            strefaButton.setTitle("-----", for: .normal)
            adresField.text = ""
            adresField.isEnabled = false
            adresField.placeholder = "-----"
            numerField.text = ""
            numerField.isEnabled = false
            numerField.placeholder = "-----"
            kodField.text = ""
            kodField.isEnabled = false
            kodField.placeholder = "-----"
            miastoField.text = ""
            miastoField.isEnabled = false
            miastoField.placeholder = "-----"
        }

        //formatowanie i wyświetlanie ceny dostawy
        let numDostawa = formatter1.string(from: NSNumber(value: Float(dostarczenie)!))
        cenaDostawyLabel.text = "\(numDostawa! ) " + "L_PLN".localized()//cena dostawy
        
        //obliczenie, formatowanie i wyświetlenie ceny całkowitej
        let calkowitaFloat = Float(cenaMenuOpakowania) + Float(dostarczenie)!
        let numCalkowita = formatter1.string(from: NSNumber(value: calkowitaFloat))
        cenaCalkowitaLabel.text = "\(numCalkowita! ) " + "L_PLN".localized()//menu + opak + dostawa

    
        //formularz - odczytanie danych z pamięci podręcznej (a może trzeba zrobić że z bazy???)
        miejsceLabel.text = "L_MIEJSCE".localized()
        zamawiajacyLabel.text = "L_ZAMAWIAJACY".localized()
        informacjeLabel.text = "L_INFORMACJE".localized()
        zaplataLabel.text = "L_SPOSOB_ZAPLATY".localized()

        imieLabel.text = "L_IMIE".localized()
        imieField.placeholder = "L_IMIE_HOLDER".localized()
        nazwiskoLabel.text = "L_NAZWISKO".localized()
        nazwiskoField.placeholder = "L_NAZWISKO_HOLDER".localized()
        telefonLabel.text = "L_TELEFON".localized()
        telefonField.placeholder = "L_TELEFON_HOLDER".localized()
        emailLabel.text = "L_EMAIL".localized()
        emailField.placeholder = "L_EMAIL_HOLDER".localized()
        dostawaLabel.text = "L_DOSTAWA".localized()
        uwagiLabel.text = "L_UWAGI".localized()
        uwagiField.placeholder = "L_UWAGI_HOLDER".localized()
        
        imieField.text = Shared.shared.imie
        nazwiskoField.text = Shared.shared.nazwisko
        telefonField.text = Shared.shared.telefon
        emailField.text = Shared.shared.email
        czasField.text = "L_JAK_NAJSZYBCIEJ".localized()

        //ustalenie zakresu godzin dostawy
        let date = Date() //aktualna data
        let calendar = Calendar.current
        let aktualna_godzina = calendar.component(.hour, from: date)//aktualna godzina
        //let aktualny_dzien = calendar.component(.weekday , from: date) //1-niedziela
        
        //wyciągnięcie z np. 22.30 tylko godziny czyli 22 ( array[0] = 22, array[1] = 30)
        let array = String(Shared.shared.strefy[0].zamow_do).components(separatedBy: ".")
        //print(array[0])

        //wygenerowanie tablicy z czasami do wyboru w pickerze
        if (aktualna_godzina + 1) < Int(array[0])! {
            for start in aktualna_godzina + 1 ... Int(array[0])!{
                czasy.append(String(start) + ":00")
                czasy.append(String(start) + ":15")
                czasy.append(String(start) + ":30")
                czasy.append(String(start) + ":45")
            }
        }
        
        //pole czas dostawy
        pickerView.delegate = self
        pickerView.dataSource = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedGodz))
        toolbar.setItems([done], animated: false)
        czasField.inputAccessoryView = toolbar
        czasField.inputView = pickerView
        czasField.placeholder = "L_CZAS_DOSTAWY".localized()
        
        //radiobatony sposobu zapłaty - musi być conajmniej płatność gotówką więc:
        let frame1 = CGRect(x: 40, y: 720, width: view.frame.width - 60, height: 25)
        let firstRadioButton1 = createRadioButton1(frame: frame1, title: "L_GOTOWKA".localized(), index: 0)
        
        //other buttons
        var i1 = 1;
        var opcje1 = [String]()
        //re_platne_dos: 1(001)gotówka, 2(010)karta, 3(011)gotówka i karta, 4(100)Internet, 5(101)gotówka i Internet, 7(111)gotówka, karta i Internet,...
        //ponieważ musi być conajmniej płatność gotówką więc 1 jest w firstRadioButton1
        //poniżej jest dorabianie reszty sposobów płatności
        if Int(Shared.shared.strefy[Shared.shared.strefa].re_platne_dos)! > 1{
            switch Int(Shared.shared.strefy[Shared.shared.strefa].re_platne_dos)! {
                case 3: opcje1.append("L_KARTA".localized())
                case 5: opcje1.append("L_ONLINE".localized())
                case 7: opcje1.append("L_KARTA".localized())
                        opcje1.append("L_ONLINE".localized())
                default: break
            }
        }
            //let opcje1 = ["L_KARTA".localized(), "L_ONLINE".localized()];
            
        var otherButtons1 : [DLRadioButton] = [];
        for opcja1 in opcje1 {
            let frame1 = CGRect(x: 40, y: 720 + 35 * CGFloat(i1), width: view.frame.width - 60, height: 25);
            let radioButton1 = createRadioButton1(frame: frame1, title: opcja1, index: i1);
            otherButtons1.append(radioButton1);
            i1 += 1;
        }
        firstRadioButton1.otherButtons = otherButtons1;
        
        
        
        
        //akceptacja regulaminu
        var tag = 0
        let box = BEMCheckBox(frame: CGRect(x: 40, y: 730 + 35 * CGFloat(i1), width: 20, height: 20))
        box.minimumTouchSize = CGSize(width: 600, height: 20)
        box.boxType = BEMBoxType.square
        box.animationDuration = 0.5
        box.onAnimationType = BEMAnimationType.fill
        box.offAnimationType = BEMAnimationType.fill
        box.onFillColor = UIColor.red
        box.onTintColor = UIColor.red
        box.onCheckColor = UIColor.white
        box.tag = tag
        tag += 1
        box.delegate = self
        self.dostawaView.addSubview(box)
        
        let text = UILabel(frame: CGRect(x: 70, y: 725 + 35 * CGFloat(i1), width: 350, height: 30))
        text.font = UIFont(name: "Arial", size: 14)
        text.textColor = UIColor.gray
        text.text = "L_AKCEPTUJE_REGULAMIN".localized()
        self.dostawaView.addSubview(text)
        
        
        //przycisk "Regulamin"
        let regulaminButton = UIButton.init(type: .system)
        regulaminButton.frame = CGRect(x: 10, y: Int(780 + 35 * CGFloat(i1)), width: Int(self.view.frame.size.width/2 - 15), height: 40)
        regulaminButton.setTitle("L_REGULAMIN".localized(), for: .normal)
        regulaminButton.titleLabel?.textColor = UIColor.white
        regulaminButton.tintColor = UIColor.white
        regulaminButton.layer.cornerRadius = 5.0
        regulaminButton.backgroundColor = UIColor.gray
        regulaminButton.addTarget(self, action: #selector(buttonRegulaminDostawyClic(_ :)), for: .touchUpInside)
        self.dostawaView.addSubview(regulaminButton)
        
        //przycisk "rezygnuje"
        let rezygnujeButton = UIButton.init(type: .system)
        rezygnujeButton.frame = CGRect(x: Int(self.view.frame.size.width/2 + 5), y: Int(780 + 35 * CGFloat(i1)), width: Int(self.view.frame.size.width/2 - 15), height: 40)
        rezygnujeButton.setTitle("L_REZYGNUJE".localized(), for: .normal)
        rezygnujeButton.titleLabel?.textColor = UIColor.white
        rezygnujeButton.tintColor = UIColor.white
        rezygnujeButton.layer.cornerRadius = 5.0
        rezygnujeButton.backgroundColor = UIColor.gray
        rezygnujeButton.addTarget(self, action: #selector(buttonRezygnujeClic(_ :)), for: .touchUpInside)
        self.dostawaView.addSubview(rezygnujeButton)
        
        //przycisk "zamawiam"
        let dostawaButton = UIButton.init(type: .system)
        dostawaButton.frame = CGRect(x: 10, y: Int(830 + 35 * CGFloat(i1)), width: Int(self.view.frame.size.width - 20), height: 40)
        dostawaButton.setTitle("L_ZAMAWIAM".localized(), for: .normal)
        dostawaButton.titleLabel?.textColor = UIColor.white
        dostawaButton.tintColor = UIColor.white
        dostawaButton.layer.cornerRadius = 5.0
        dostawaButton.backgroundColor = Shared.shared.malinaColor
        dostawaButton.addTarget(self, action: #selector(buttonZamawiamClic(_ :)), for: .touchUpInside)
        self.dostawaView.addSubview(dostawaButton)

        
    }
    
    //obsługa przycisku done na toolbarze godziny (zmienić!!! na Gotowe i Anuluj)
    @objc func donePressedGodz(){
        self.view.endEditing(true)
    }
    
    @objc func buttonRegulaminDostawyClic(_ : UIButton){
        performSegue(withIdentifier: "sbRegulaminDostawy", sender: self) //przejście
    }
    
    @objc func buttonRezygnujeClic(_ : UIButton){
          _ = navigationController?.popViewController(animated: true)//powrót do poprzedniego view
    }
    
    //-----------------------------------------
    //obsługa przycisku Zamawiam
    //-----------------------------------------
    @objc func buttonZamawiamClic(_ : UIButton){
        
        //Odczytanie pól tekstowych
        Shared.shared.adres = adresField.text
        Shared.shared.numer = numerField.text
        Shared.shared.kod = kodField.text
        Shared.shared.miasto =  miastoField.text
        Shared.shared.imie = imieField.text
        Shared.shared.nazwisko = nazwiskoField.text
        Shared.shared.telefon =  telefonField.text
        Shared.shared.email = emailField.text
//print("doarawa=")
//print(Shared.shared.dostawa)
        //Sprawdzenie czy pola nie są puste
      
        if Shared.shared.dostawa == 1{  //jeżeli odbiór własny
            if (Shared.shared.imie?.isEmpty)! || (Shared.shared.nazwisko?.isEmpty)! || (Shared.shared.telefon?.isEmpty)! || (Shared.shared.email?.isEmpty)!{
            
                displayMessageForm(userMessage: "L_WPROWADZ_DANE".localized())
            return
            }
        }else{  //jeżeli dostawa
            if (Shared.shared.adres?.isEmpty)! || (Shared.shared.numer?.isEmpty)! || (Shared.shared.kod?.isEmpty)! || (Shared.shared.miasto?.isEmpty)! || (Shared.shared.imie?.isEmpty)! || (Shared.shared.nazwisko?.isEmpty)! || (Shared.shared.telefon?.isEmpty)! || (Shared.shared.email?.isEmpty)!{
                
                displayMessageForm(userMessage: "L_WPROWADZ_DANE".localized())
                return
            }
            if Shared.shared.platnosc == 0 {
                displayMessageForm(userMessage: "L_WYBIERZ_PLATNOSC".localized())
                return
            }
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
        
        //send HTTP Request to Dostawa
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_dostawa.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var czas = ""
        if czasField.text! == czasy[0] { czas = "0.99"}
        else {czas = czasField.text!}
        
        var koszt = ""
        if miastoField.text! == "" { koszt = "0,00"}
        else {koszt = Shared.shared.koszt!}
        
        let postString = ["za_uz_id": Shared.shared.uz_id,
                          "za_re_id": location![0].e,
                          "za_typ": "1",                     //1 - dostawa
                          "za_data": "1",   //data wstawiana w skrypcie php na serwerze
                          "za_godz": czas,
                          "za_adres": Shared.shared.adres,
                          "za_numer": Shared.shared.numer,
                          "za_kod": Shared.shared.kod,
                          "za_miasto": Shared.shared.miasto,
                          "za_imie": Shared.shared.imie,
                          "za_nazwisko": Shared.shared.nazwisko,
                          "za_telefon": Shared.shared.telefon,
                          "za_email": Shared.shared.email,
                          "za_uwagi": uwagiField.text!,
                          "za_platnosc": String(Shared.shared.platnosc),
                          "za_koszt": koszt,
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
                //print ("json:====== \(String(describing: json!))")
                //print ("json:==\(String(describing: json!["error_email"]!))")
                let zapis = String(describing: json!["zapis"])
                let success = String(describing: json!["success"])
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
        //performSegue(withIdentifier: "sbDostawa", sender: self) //przejście do DostawaVC
    }
    
    
    //usuwanie klawiatury z ekranu po naciśnięciu "Return" (działa przez delegata textField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //obsłuda pickera z czasami dostawy
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1}
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return czasy.count}
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return czasy[row] }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        czasField.text = czasy[row]
        //czasField.resignFirstResponder()
    }
    
    //tworzenie radiobatonów dostawy
    private func createRadioButton(frame : CGRect, title : String, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14);
        radioButton.tag = index

        //ustawienie czerwonej kropki na języku zapisanym w pamięci
        switch index {
        case 0: if Shared.shared.dostawa == 0 { radioButton.isSelected = true}
        case 1: if Shared.shared.dostawa == 1 { radioButton.isSelected = true}

        default: break //print("index języka poza zakresem ")
        }
        radioButton.marginWidth = 10
        radioButton.setTitle(title, for: []);
        radioButton.setTitleColor(UIColor.black, for: []);
        radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        radioButton.iconSize = 20
        
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(DostawaViewController.logSelectedButton), for: UIControlEvents.touchUpInside);
        self.dostawaView.addSubview(radioButton);
        
        return radioButton;
    }
 
    //tworzenie radiobatonów sposobu zapłaty
    private func createRadioButton1(frame : CGRect, title : String, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14);
        radioButton.tag = index
        
        //ustawienie czerwonej kropki na sposobie zapłaty zapisanym w pamięci
        switch index {     //płatnosci: 0-brak danych, 1-gotówka, 2-karta, 3-internet
        case 0: if Shared.shared.platnosc == 1 { radioButton.isSelected = true}
        case 1: if Shared.shared.platnosc == 2 { radioButton.isSelected = true}
        case 2: if Shared.shared.platnosc == 3 { radioButton.isSelected = true}
        default: break
        }
        radioButton.marginWidth = 10
        radioButton.setTitle(title, for: []);
        radioButton.setTitleColor(UIColor.black, for: []);
        radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        radioButton.iconSize = 20
        
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(DostawaViewController.logSelectedButton1), for: UIControlEvents.touchUpInside);
        self.dostawaView.addSubview(radioButton);
        
        return radioButton;
    }
    
    
    //----------------------------------
    //wybór sposobu płatności za dostawę
    //----------------------------------
    @objc @IBAction private func logSelectedButton1(radioButton : DLRadioButton) {
        //zapisanie płatności: 1 - Gotówka, 2 - Karta, 3 - Internet
        switch radioButton.selected()!.tag {
            case 0: Shared.shared.platnosc = 1
            case 1: Shared.shared.platnosc = 2
            case 2: Shared.shared.platnosc = 3
       
        default: Shared.shared.platnosc = 0 //0 - brak danych
        }
       
    }
    
    
    //----------------------------------
    //zmiana: Dostawa / Odbiór własny
    //----------------------------------
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
        
        //zapisanie wybranej formy do pamięci: 0 - dostawa, 1 - odbiór własny
        switch radioButton.selected()!.tag {
            case 0: Shared.shared.dostawa = 0
                    radioButton.isSelected = true
                    let dostarczenie = Shared.shared.koszt!
                    //formatowanie i wyświetlanie ceny dostawy
                    let numDostawa = formatter1.string(from: NSNumber(value: Float(dostarczenie)!))
                    cenaDostawyLabel.text = "\(numDostawa! ) " + "L_PLN".localized()//cena menu + opakowania
            
                    //do ceny menu doliczana jest cena opakowań
                    let cenaMenuOpakowania = Float(Shared.shared.cenaRazem)! + Float(Shared.shared.kosztOpakowan)!
                    let numMenu = formatter1.string(from: NSNumber(value: cenaMenuOpakowania))
                    cenaMenuLabel.text = "\(numMenu! ) " + "L_PLN".localized()//cena menu + opakowania
            
                    //obliczenie, formatowanie i wyświetlenie ceny całkowitej
                    let calkowitaFloat = Float(cenaMenuOpakowania) + Float(dostarczenie)!
                    let numCalkowita = formatter1.string(from: NSNumber(value: calkowitaFloat))
                    cenaCalkowitaLabel.text = "\(numCalkowita! ) " + "L_PLN".localized()//cena menu + opakowania
 
                    strefaButton.isEnabled = true
                    strefaButton.setTitleColor(UIColor.black, for: .normal)
                    strefaButton.backgroundColor = .clear
                    strefaButton.setTitle("L_STREFA".localized() + " " + String(Shared.shared.strefa + 1), for: .normal)
                    adresField.text = Shared.shared.adres
                    numerField.text = Shared.shared.numer
                    kodField.text = Shared.shared.kod
                    miastoField.text = Shared.shared.miasto
                    adresField.isEnabled = true
                    adresField.placeholder = "L_ADRES_HOLDER".localized()
                    numerField.isEnabled = true
                    numerField.placeholder = "L_NUMER_HOLDER".localized()
                    kodField.isEnabled = true
                    kodField.placeholder = "L_KOD_HOLDER".localized()
                    miastoField.isEnabled = true
                    miastoField.placeholder = "L_MIASTO_HOLDER".localized()
            case 1: Shared.shared.dostawa = 1
                    radioButton.isSelected = true
                    let dostarczenie = "0.00"
                    //formatowanie i wyświetlanie ceny dostawy
                    let numDostawa = formatter1.string(from: NSNumber(value: Float(dostarczenie)!))
                    cenaDostawyLabel.text = "\(numDostawa! ) " + "L_PLN".localized()//cena menu + opakowania
            
                    //do ceny menu doliczana jest cena opakowań
                    let cenaMenuOpakowania = Float(Shared.shared.cenaRazem)! + Float(Shared.shared.kosztOpakowan)!
                    let numMenu = formatter1.string(from: NSNumber(value: cenaMenuOpakowania))
                    cenaMenuLabel.text = "\(numMenu! ) " + "L_PLN".localized()//cena menu + opakowania
            
                    //obliczenie, formatowanie i wyświetlenie ceny całkowitej
                    let calkowitaFloat = Float(cenaMenuOpakowania) + Float(dostarczenie)!
                    let numCalkowita = formatter1.string(from: NSNumber(value: calkowitaFloat))
                    cenaCalkowitaLabel.text = "\(numCalkowita! ) " + "L_PLN".localized()//cena menu + opakowania
            
                    strefaButton.isEnabled = false
                    strefaButton.setTitleColor(UIColor.lightGray, for: .normal) //darkGray
                    strefaButton.backgroundColor = Shared.shared.mojSzary
                    strefaButton.setTitle("-----", for: .normal)
                    adresField.text = ""
                    adresField.isEnabled = false
                    adresField.placeholder = "-----"
                    numerField.text = ""
                    numerField.isEnabled = false
                    numerField.placeholder = "-----"
                    kodField.text = ""
                    kodField.isEnabled = false
                    kodField.placeholder = "-----"
                    miastoField.text = ""
                    miastoField.isEnabled = false
                    miastoField.placeholder = "-----"
            default: Shared.shared.dostawa = 0
            }
    }
    
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator.removeFromSuperview()
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
    
    //obsługa checkboxa
    func didTap(_ checkBox: BEMCheckBox) { //tag = indeks
        if checkBox.on {
            Shared.shared.akceptuje = "tak"
            //print("tak")
        }else {
            Shared.shared.akceptuje = "nie"
            //print("nie") 
        }
        //print(checkBox.tag)
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
    
    //===============================================
    //wyświetlenie okna popup - wybór strefy dostawy
    //===============================================
    @IBAction func showPopup(_ sender: Any) {
        let popup0VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpStrefy") as! StrefyViewController
        
        self.addChildViewController(popup0VC)
        popup0VC.view.frame = self.view.frame
        popup0VC.delegate = self  //1 utworzenie delegata w widoku z którego mają wrócić dane
        self.view.addSubview(popup0VC.view)
        popup0VC.didMove(toParentViewController: self)
    }
}

//===========================================================
//4 rozszerzenie klasy pobierajacej dane o protokół delegata
//implementacja protokołu delegata
//dane z delegata w StrefyViewController przekazane do klasy pobierajacej dane czyli DostawaViewController
//===========================================================
extension DostawaViewController: PopupDelegate3{
    func popupValueSelected3(value: Int) {
        Shared.shared.strefa = value
        strefaButton.setTitle("L_STREFA".localized() + " " + String(Shared.shared.strefa + 1), for: .normal)
        
        //obliczenie kosztów dostawy
        let razem = Float(Shared.shared.cenaRazem.replacingOccurrences(of: ",", with: "."))
        if((razem!) > (Float(Shared.shared.strefy[Shared.shared.strefa].str_wart_max))!){
            Shared.shared.koszt = Shared.shared.strefy[Shared.shared.strefa].str_koszt_bonus
        }else{
            Shared.shared.koszt = Shared.shared.strefy[Shared.shared.strefa].str_koszt
        }
        
        cenaDostawyLabel.text = "\(Shared.shared.koszt!.replacingOccurrences(of: ".", with: ",")) " + "L_PLN".localized()
        let dostarczenie = Shared.shared.koszt.replacingOccurrences(of: ",", with: ".")
        let cenaRazemFloat = Shared.shared.cenaRazem.replacingOccurrences(of: ",", with: ".")
        let calkowitaFloat = Float(cenaRazemFloat)! + Float(dostarczenie)!
        let calkowitaString = String(calkowitaFloat)
        let calkowita = calkowitaString.replacingOccurrences(of: ".", with: ",")
        cenaCalkowitaLabel.text = "\(calkowita)0 " + "L_PLN".localized()
        
        //self.viewDidLoad() //przeładowanie widoku
    
    }
}
