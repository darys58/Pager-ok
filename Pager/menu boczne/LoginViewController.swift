//
//  LoginViewController.swift
//  Pager
//
//  Created by darys on 23.04.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Localize_Swift
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate{
     
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var hasloLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    var user: [Memorydb]? = []         //dane usera zapamiętane w bazie lokalnej
    var reachability: Reachability?  //dostępność Internetu
    var loginLabel = UILabel()
    var activityIndicator = UIActivityIndicatorView()
    var rodzajSkladnika = [RodzajSk]()      //dane z JSONa - kategorie składników pobrane z www
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginLabel.frame = CGRect(x: 170, y: 120, width: 200, height: 30)
        loginLabel.text = "L_LOGOWANIE".localized()
        loginLabel.font.withSize(16) //= UIFont.SystemFont (ofSize: 16)
        self.view.addSubview(loginLabel)
        
        emailLabel.text = "L_LOGIN_EMAIL".localized()
        userNameTextField.placeholder = "L_LOGIN_EMAIL".localized()

        hasloLabel.text = "L_HASLO".localized()
        userPasswordTextField.placeholder = "L_HASLO".localized()
        
        //własny button logowania
        let myloginButton = UIButton()
        myloginButton.backgroundColor = UIColor(red:200/255, green:0/255, blue:0/255, alpha:1.0)
        myloginButton.frame = CGRect(x: 16, y: 350, width: view.frame.width - 32, height: 50)
        myloginButton.layer.cornerRadius = 5
        myloginButton.setTitle("L_ZALOGUJ".localized(), for: .normal)
        myloginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        myloginButton.setTitleColor(.white , for: .normal)
        view.addSubview(myloginButton)
        myloginButton.addTarget(self, action: #selector(singInButtonTapped), for: .touchUpInside)
        
        
        //własny button logowania przez FB
        let customFBButton = UIButton()
        customFBButton.backgroundColor = UIColor(red:59/255, green:89/255, blue:152/255, alpha:1.0)
        customFBButton.frame = CGRect(x: 16, y: 416, width: view.frame.width - 32, height: 50)
        customFBButton.layer.cornerRadius = 5
        customFBButton.setTitle("L_ZALOGUJ_FB".localized(), for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customFBButton.setTitleColor(.white , for: .normal)
        view.addSubview(customFBButton)
        customFBButton.addTarget(self, action: #selector(hangleCustomFBLogin), for: .touchUpInside)
        
        //rejestracja button. Przejście do RegisterViewController zrobione jest w Storybordzie
        registerButton.setTitle("L_UTWORZ_KONTO".localized(), for: .normal)
        registerButton.setTitleColor(.white , for: .normal)
        
        //----- wskaźnik aktywności-----------
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        //------------------------------------
        
    }

    //usuwanie klawiatury z ekranu po naciśnięciu "Return" (działa przez delegata textField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //------------------------------------------------------
    //logowanie przez FB z własnym buttonem logowania do FB
    //------------------------------------------------------
    @objc func hangleCustomFBLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) {(result, err) in
            if err != nil {
                print("Błąd custom FB Login, err")
                return
            }
            
            //pobranie parametrów usera z facebooka
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
                (connection, result, err) in
                if err != nil {
                    print("Błąd w start graph request")
                    return
                }
                
                let dictionery = result as! [String: AnyObject]
                print (dictionery) //["id": 1815694608461068, "name": Antoni Daryszewski, "email": darys2@wp.pl]
                if let name = dictionery["name"]{ //???
                    print (name)
                }
                var name1 = ""
                if dictionery["name"] != nil {
                    name1 = "\(String(describing: dictionery["name"]!))"
                }else{
                    name1 = "\(String(describing: dictionery["email"]!))"
                }
                //----- wskaźnik aktywności-------
                self.activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                //---------------------------------
                
                //send HTTP Request to Login user
                let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_login.php")
                var request = URLRequest(url: myUrl!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "content-type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let postString = ["login": name1,
                                  "email": dictionery["email"]!,
                                  "id": dictionery["id"]!] as! [String: String]
                do{
                    request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
                }catch let error {
                    print(error.localizedDescription)
                    self.displayMessage(userMessage: "L_COS_NIE_TAK".localized())
                    return
                }
                
    
                let task = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
                    //print("data======\(String(describing: data))")
                    //self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                    
                    if error != nil { //jezeli nil tzn. ze sie powiodło
                        self.displayMessage(userMessage: "L_LOG_ERROR".localized())
                        print("error======\(String(describing: error))")
                        return
                    }
                    
                    //konwertowanie danych odebranych z serwera
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        //print ("json:====== \(String(describing: json!))")
                        //print ("json:=\(json!["uz_typ"] ?? "0")")
                        
                        
                        let success = "\(json!["success"]!)"     //let success = String(describing: json!["success"])
                        //print("success=\(success)")
                        
                        if (success != "1"){ //logowanie nie powiodło sie
                            self.displayMessage(userMessage: "L_LOG_ERROR".localized())
                            return
                        }else{ //logowanie powiodło się
                            let uz_id = "\(json!["uz_id"]!)"
                            let uz_login = "\(json!["uz_login"]!)"
                            let uz_email = "\(json!["uz_email"]!)"
                            let uz_student = "\(json!["uz_student"]!)"
                            let uz_au_id = "\(json!["uz_au_id"]!)"
                            //let uz_woj = "\(json!["uz_woj"]!)"
                            

                            //zapisanie danych użytkownika do bazy
                            _ = StephencelisDB.instance.updateMemory(mem: "mem_user", a: uz_id, b: uz_login, c: uz_email, d: uz_student, e: uz_au_id, f: "")
                            
                            //pobranie danych z bazy...
                            //mem_user (a:uz_id, b:uz_login, c:uz_email, d:uz_student, e:uz_miasto, f:uz_woj)
                            self.user = StephencelisDB.instance.getMemory(memo: "mem_user")
                            
                            //...i zapamiętanie w pamięci podręcznej
                            Shared.shared.uz_id = "\(self.user![0].a)"
                            Shared.shared.uz_login = "\(self.user![0].b)"
                            Shared.shared.uz_email = "\(self.user![0].c)"
                            Shared.shared.uz_student = "\(self.user![0].d)"
                            
                            //print ("czy uz_id=\(Shared.shared.uz_id)")
                            
                            //jeżeli logowanie się powiodło - wczytanie dań zalogowanego
                            if Shared.shared.uz_id != ""{
                                //self.displayMessage(userMessage: "Logowanie powiodło się.")
                                var siec: Network?
                                var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
                                siec = Network()
                                //wczytanie (update) aktualnego zakresu wartości filtrów z www (od min do max)
                                siec!.importujFiltr()
                                
                                _ = StephencelisDB.instance.deleteDaniaAll()   //zerowanie tabeli 'dania' w bazie lokalnej
                                
                                //pobranie lokalizacji z tabeli 'memory->mem_lok'
                                location = StephencelisDB.instance.getMemory(memo: "mem_lok")

                                //pobranie dań z serwera dla wybranej restauracji
                                
                                //czy jest restauracja? bo jeśli nie to załaduj domyślne (wszystkie z Konina)(bez filtrów bo skasowane i uaktualnione)
                                if location![0].e != "0" { //jeżeli aktualnie nie są wybrane "Wszystkie" rest w mieście
                                    let czy_jest_rest = StephencelisDB.instance.czyRestauracja(rest: location![0].e)
                                    if czy_jest_rest > 0{ //wybrana restauracja istnieje w bazie (czy_jest_rest = 1)
                                        _ = siec?.importujDania(link: "https://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(uz_id)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())")
                                    }else{ //restauracji nie ma już w bazie www (bo np. została usunięta) - ładuje domyślne
                                        _ = siec?.importujDania(link: "https://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(uz_id)&woj_id=14&mia_id=1&rest=0&lang=\(Localize.currentLanguage())")
                                    }
                                }else{ //są wybrane "Wszystkie"
                                    //pobranie dań dla wszystkich restauracji w miescie (bez filtrów bo skasowane i uaktualnione)
                                    _ = siec?.importujDania(link: "https://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(uz_id)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())")
                                }
                                //print("pobrane dane ")
                                
                                //pobranie kategorii składników
                                self.downloadJSON_rodzaje{
                                    //skasowanie wszystkich kategorii składników
                                    _ = StephencelisDB.instance.deleteRodzajeAll()
                                    //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                                    for rodz in self.rodzajSkladnika {
                                        _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                                    }
                                    
                                }
                                
                            }else{
                                self.displayMessage(userMessage: "L_LOG_ERROR".localized())
                            }
                        }
                        
                    } catch{
                        //self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                        self.displayMessage(userMessage: "L_LOG_ERROR".localized())
                        print(error)
                    }
                }
                
                task.resume()
                
                
                
                //opóźnienie żeby zdążyło przeładować dane
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                    
                    //Zwłoka do czasu pobrania wszystkich dań z internetu do bazy lokalnej
                    var aaa = 0
                    while Shared.shared.ileDanJSON != aaa {
                        sleep(1) //opóźnienie = 1 sek.
                        aaa = Shared.shared.liczDania + 1 //ilość wczytanych dań - licznik w Network.swift
                    }
                    
                    AppDelegate.refresh_list_meal = true
                    //----- wskaźnik aktywności-------
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    //---------------------------------
                    self.performSegue(withIdentifier: "unwindToParentFromLogin", sender: self)
                }
            
            }

        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print ("wylogowany...")
    }
    
  
    //---------------------------------------
    //logowanie z wpisaniem loginu i hasła
    //---------------------------------------
    @objc func singInButtonTapped() {
        
        var siec: Network?
        var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
        
        //Odczytanie pól tekstowych
        let userName = userNameTextField.text
        let userPassword = userPasswordTextField.text
        
        //Sprawdzenie czy pola nie są puste
        if(userName?.isEmpty)! || (userPassword?.isEmpty)!{
            print("Empty")
            
            displayMessage(userMessage: "L_WPROWADZ_DANE".localized())
            return
        }
        

        //----- wskaźnik aktywności-------
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        //---------------------------------
       
        //send HTTP Request to Login user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_login.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["login": userName!,
                          "password": userPassword!] as [String: String]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch let error {
            print ("Error -0-  ")
            print(error.localizedDescription)
            displayMessage(userMessage: "L_COS_NIE_TAK".localized())
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            //print("data======\(String(describing: data))")
  //          self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil { //jezeli nil tzn. ze sie powiodło
                self.displayMessage(userMessage: "L_LOG_ERROR".localized())
                print("error===1===\(String(describing: error))")
                return
            }
            
            //konwertowanie danych odebranych z serwera
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                //print ("json:====== \(String(describing: json!))")
                //print ("json:=\(json!["uz_typ"] ?? "0")")
                
                
                let success = "\(json!["success"]!)"     //let success = String(describing: json!["success"]) 
                //print("success=\(success)")
                
                if (success != "1"){ //logowanie nie powiodło sie
                    self.displayMessage(userMessage: "L_LOG_ERROR".localized())
                    print ("logowanie error  2")
                    return
                }else{ //logowanie powiodło się
                    let uz_id = "\(json!["uz_id"]!)"
                    let uz_login = "\(json!["uz_login"]!)"
                    let uz_email = "\(json!["uz_email"]!)"      //print("mail=\(uz_email)")
                    let uz_student = "\(json!["uz_student"]!)"
                    let uz_au_id = "\(json!["uz_au_id"]!)"
                    //let uz_woj = "\(json!["uz_woj"]!)"
                    

                    //zapisanie danych użytkownika do bazy
                    _ = StephencelisDB.instance.updateMemory(mem: "mem_user", a: uz_id, b: uz_login, c: uz_email, d: uz_student, e: uz_au_id, f: "")
                    
                    //zapamietanie reakcji na alergeny dla zalogowanego
                    //pobranie danych z bazy...
                    //mem_user (a:uz_id, b:uz_login, c:uz_email, d:uz_student, e:uz_au_id, f:uz_??)
                    self.user = StephencelisDB.instance.getMemory(memo: "mem_user")
                    
                    //...i zapamiętanie w pamięci podręcznej
                    Shared.shared.uz_id = "\(self.user![0].a)"
                    Shared.shared.uz_login = "\(self.user![0].b)"
                    Shared.shared.uz_email = "\(self.user![0].c)"
                    Shared.shared.uz_student = "\(self.user![0].d)"
                    
                    //jeżeli logowanie się powiodło - wczytanie dań zalogowanego
                    if Shared.shared.uz_id != ""{
                        //self.displayMessage(userMessage: "Logowanie powiodło się.")
                       
                        siec = Network()
                        //wczytanie (update) aktualnego zakresu wartości filtrów z www (od min do max)
                        siec!.importujFiltr()
                        
                        _ = StephencelisDB.instance.deleteDaniaAll()   //zerowanie tabeli 'dania' w bazie lokalnej
                        
                        //pobranie lokalizacji z tabeli 'memory->mem_lok'
                        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
                        
                        //pobranie dań z serwera dla wybranej restauracji
                        
                        Shared.shared.liczDania = 0 //zerowanie liczby pobranych dań
                        
                        //czy jest restauracja? bo jeśli nie to załaduj domyślne (wszystkie z Konina)(bez filtrów bo skasowane i uaktualnione)
                        if location![0].e != "0" { //jeżeli aktualnie nie są wybrane "Wszystkie" rest w mieście
                            let czy_jest_rest = StephencelisDB.instance.czyRestauracja(rest: location![0].e)
                            
                            if czy_jest_rest > 0{ //wybrana restauracja istnieje w bazie (czy_jest_rest = 1)
                                _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(uz_id)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())")
                            }else{ //restauracji nie ma już w bazie www (bo np. została usunięta) - ładuje domyślne
                                _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(uz_id)&woj_id=14&mia_id=1&rest=0&lang=\(Localize.currentLanguage())")
                            }
                        }else{ //są wybrane "Wszystkie"
                            //pobranie dań dla wszystkich restauracji w miescie (bez filtrów bo skasowane i uaktualnione)
                            _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(uz_id)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())")
                        }
                        //print("pobrane dane ")
                        
                        //pobranie kategorii składników
                        self.downloadJSON_rodzaje{
                            //skasowanie wszystkich kategorii składników
                            _ = StephencelisDB.instance.deleteRodzajeAll()
                            //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                            for rodz in self.rodzajSkladnika {
                                _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                            }
                        }
                       
                    }else{
                        self.displayMessage(userMessage: "L_LOG_ERROR".localized())
                        print ("logowanie error  3")
                        return
                    }
                }
                
            } catch{
                //----- wskaźnik aktywności-------
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                //---------------------------------
                self.displayMessage(userMessage: "L_LOG_ERROR".localized())
                print ("logowanie error  4")
                print(error)
                return
            }
        }
        
        task.resume()
      
        //if Shared.shared.uz_id != ""{ //jeżeli udało się zalogować
            //opóźnienie żeby zdążyło przeładować dane
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                
                //Zwłoka do czasu pobrania wszystkich dań z internetu do bazy lokalnej
                var aaa = 0
                while Shared.shared.ileDanJSON != aaa {
                    sleep(1) //opóźnienie = 1 sek.
                    aaa = Shared.shared.liczDania + 1 //ilość wczytanych dań - licznik w Network.swift
                }
                
                AppDelegate.refresh_list_meal = true
                //----- wskaźnik aktywności-------
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                //---------------------------------
                self.performSegue(withIdentifier: "unwindToParentFromLogin", sender: self)
                return
            }
       // }
        
    }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
    }
 
    //komunikat
/*    func displayMessage(userMessage:String) {
        let alertViev = UIAlertController (title: "L_ALERT".localized(), message: userMessage, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        self.present(alertViev, animated: true, completion: nil)
    }
 */
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //code
                //print ("OK")
              //DispatchQueue.main.async {
               //     self.dismiss(animated: true, completion: nil)
             //   }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
  
    //=========================================================
    //funkcja pobierająca JSONa z kategoriami składników
    //skrypt ios_rodzaje_do.php decyduje czy pobiera składniki startowe czy normalne
    //=========================================================
    func downloadJSON_rodzaje(completed: @escaping () -> ()) {
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_rodzaje_do&uz_id=\(Shared.shared.uz_id!)&lang=\(Localize.currentLanguage())")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    self.rodzajSkladnika = try JSONDecoder().decode([RodzajSk].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print ("JSON Error")
                }
            }
        }.resume()
    }
}
