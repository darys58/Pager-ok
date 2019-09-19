//
//  DoStolikaViewController.swift
//  Pager
//
//  Created by darys on 20.06.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Localize_Swift

class DoStolikaViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var kosztLabel: UILabel!
    @IBOutlet weak var kodLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var uwagiLabel: UILabel!
    
    @IBOutlet weak var kodField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var uwagiField: UITextField!
    
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var zamZam = [Zamowienie]()  //tablica zamówień
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tytuł ekranu
        let titlelabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel1
        titlelabel1.text = "L_DO_STOLIKA".localized()
        titlelabel1.textAlignment = .center
        
        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
        let koszt = Float(Shared.shared.cenaRazem)!
        let numKoszt = formatter1.string(from: NSNumber(value: koszt))

        kosztLabel.text = "L_KOSZT_ZAM".localized() + ": " + numKoszt! + "L_PLN".localized()
        kodLabel.text = "L_KOD".localized()
        kodField.placeholder = "L_KOD_STOLIKA_HOLDER".localized()
        //kodField.isEnabled = false  //zablokowanie pola do edycji
        emailLabel.text = "L_EMAIL".localized()
        emailField.placeholder = "L_EMAIL_HOLDER".localized()
        uwagiLabel.text = "L_UWAGI".localized()
        uwagiField.placeholder = "L_UWAGI_HOLDER".localized()
        
        emailField.text = Shared.shared.email
        
        
        //przycisk "Skanuj kod"
        let skanButton = UIButton.init(type: .system)
        skanButton.frame = CGRect(x: 10, y: 250, width: Int(self.view.frame.size.width/2 - 15), height: 40)
        skanButton.setTitle("L_SKANUJ_KOD".localized(), for: .normal)
        skanButton.titleLabel?.textColor = UIColor.white
        skanButton.tintColor = UIColor.white
        skanButton.layer.cornerRadius = 5.0
        skanButton.backgroundColor = UIColor.gray
        skanButton.addTarget(self, action: #selector(buttonSkanujClic(_ :)), for: .touchUpInside)
        self.view.addSubview(skanButton)
    
        //przycisk "rezygnuje"
        let rezygnujeButton = UIButton.init(type: .system)
        rezygnujeButton.frame = CGRect(x: Int(self.view.frame.size.width/2 + 5), y: 250, width: Int(self.view.frame.size.width/2 - 15), height: 40)
        rezygnujeButton.setTitle("L_REZYGNUJE".localized(), for: .normal)
        rezygnujeButton.titleLabel?.textColor = UIColor.white
        rezygnujeButton.tintColor = UIColor.white
        rezygnujeButton.layer.cornerRadius = 5.0
        rezygnujeButton.backgroundColor = UIColor.gray
        rezygnujeButton.addTarget(self, action: #selector(buttonRezygnujeClic(_ :)), for: .touchUpInside)
        self.view.addSubview(rezygnujeButton)
        
        //przycisk "zamawiam"
        let doStolikaButton = UIButton.init(type: .system)
        doStolikaButton.frame = CGRect(x: 10, y: 300, width: Int(self.view.frame.size.width - 20), height: 40)
        doStolikaButton.setTitle("L_ZAMAWIAM".localized(), for: .normal)
        doStolikaButton.titleLabel?.textColor = UIColor.white
        doStolikaButton.tintColor = UIColor.white
        doStolikaButton.layer.cornerRadius = 5.0
        doStolikaButton.backgroundColor = Shared.shared.malinaColor
        doStolikaButton.addTarget(self, action: #selector(buttonZamawiamClic(_ :)), for: .touchUpInside)
        self.view.addSubview(doStolikaButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Shared.shared.kod_stolika == "?"{
            displayAlertStolik()
            Shared.shared.kod_stolika = nil
        }else{
            kodField.text = Shared.shared.kod_stolika
        }
    }
    
    @objc func buttonSkanujClic(_ : UIButton){
        self.performSegue(withIdentifier: "sbScanKod", sender: self) //przejście do skanowania
    }
    
    @objc func buttonRezygnujeClic(_ : UIButton){
        _ = navigationController?.popViewController(animated: true)//powrót do poprzedniego view
    }
    
    @objc func buttonZamawiamClic(_ : UIButton){
         Shared.shared.email = emailField.text
        
        if (kodField.text?.isEmpty)! {
            displayMessageForm(userMessage: "L_WPROWADZ_DANE".localized())
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
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_dostolika.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = [
            "za_uz_id": Shared.shared.uz_id,
            "za_re_id": location![0].e,
            "za_typ": "2",              //2 - zamówienie do stolika
            "za_kod": kodField.text!,
            "za_email": Shared.shared.email,
            "za_uwagi": uwagiField.text!,
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
                //print(error)
            }
        }
        
        task.resume()
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
    
    //komunikat "Brak Internetu"
    func displayAlertStolik() {
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        
        let alertViev = UIAlertController (title: "L_BLAD_WYBORU".localized(), message: "L_W_RESTA".localized() + location![0].f + "L_NIE_MA_STOLIKA".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }
    
}
