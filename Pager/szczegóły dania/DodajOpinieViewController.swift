//
//  DodajOpinieViewController.swift
//  Pager
//
//  Created by darys on 20.07.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Cosmos
import Localize_Swift

class DodajOpinieViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var tytulLabel: UILabel!
    @IBOutlet weak var trescLabel: UILabel!
    @IBOutlet weak var autorTextField: UITextField!
    @IBOutlet weak var tytulTextField: UITextField!
    @IBOutlet weak var ocenaLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var wygladLabel: UILabel!
    @IBOutlet weak var smakLabel: UILabel!
    @IBOutlet weak var zapachLabel: UILabel!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var iloscLabel: UILabel!
    @IBOutlet weak var cenaLabel: UILabel!
    @IBOutlet weak var opisLabel: UILabel!
    @IBOutlet weak var zdjecieLabel: UILabel!
    @IBOutlet weak var cobytuLabel: UILabel!
    @IBOutlet weak var starsWyglad: CosmosView!
    @IBOutlet weak var starsSmak: CosmosView!
    @IBOutlet weak var starsZapach: CosmosView!
    @IBOutlet weak var starsTemp: CosmosView!
    @IBOutlet weak var starsIlosc: CosmosView!
    @IBOutlet weak var starsCena: CosmosView!
    @IBOutlet weak var starsOpis: CosmosView!
    @IBOutlet weak var starsZdjecie: CosmosView!
    @IBOutlet weak var starsCobytu: CosmosView!
    
    @IBOutlet weak var contentView: UIView!
    
    var reachability: Reachability?  //dostępność Internetu
    var activityIndicator = UIActivityIndicatorView()
    var memory: [Memorydb]? = []        //id dania zapamiętane w bazie lokalnej
    var meal_opinie = [MealOpinie]()    //dane z JSONa - opinie o daniu
    var moje_meal_opinie = [MealOpinie]()    //dane z JSONa - opinie o daniu
    
    override func viewDidLoad() {
        super.viewDidLoad()
//self.contentView.frame.size.height = CGFloat(1000)
       self.navigationItem.title = "L_DODAJ_OPINIE".localized()
       navigationItem.rightBarButtonItem = UIBarButtonItem(title: "L_ZAPISZ".localized(), style: .plain, target: self, action: #selector(zapisTapped))
        
        autorLabel.text = "L_AUTOR_OPINII".localized()
        tytulLabel.text = "L_TYTUL_OPINII".localized()
        trescLabel.text = "L_TRESC_OPINII".localized()
        autorTextField.placeholder = "L_AUTOR_OPINII".localized()
        tytulTextField.placeholder = "L_TYTUL_OPINII".localized()
        autorTextField.text = Shared.shared.uz_login
        
        //pole tekstowe treści opinii
 //       let textView = UITextView()
        //textView.frame = CGRect(x: 16, y: 150, width: 200, height: 100)
        //textView.backgroundColor = .lightGray
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
        textView.text = "L_TRESC_OPINII".localized()
        textView.textColor = UIColor.lightGray
        textView.font = UIFont.systemFont(ofSize: 14);
 /*       view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        [
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 210),
            //(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            //textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            textView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 32),
            textView.heightAnchor.constraint(equalToConstant: 50)
        ].forEach{$0.isActive = true}
    */
        //textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.delegate = self
        textView.isScrollEnabled = false
        textViewDidChange(textView)
    
        ocenaLabel.text = "L_OCENA_DANIA".localized()
        wygladLabel.text = "L_WYGLAD".localized()
        smakLabel.text = "L_SMAK".localized()
        zapachLabel.text = "L_ZAPACH".localized()
        temperaturaLabel.text = "L_TEMPERATURA".localized()
        iloscLabel.text = "L_ILOSC".localized()
        cenaLabel.text = "L_CENA".localized()
        opisLabel.text = "L_OPIS".localized()
        zdjecieLabel.text = "L_ZDJECIE".localized()
        cobytuLabel.text = "L_COBYTU".localized()
        starsWyglad.rating = 0
        starsSmak.rating = 0
        starsZapach.rating = 0
        starsTemp.rating = 0
        starsIlosc.rating = 0
        starsCena.rating = 0
        starsOpis.rating = 0
        starsZdjecie.rating = 0
        starsCobytu.rating = 0
        starsWyglad.settings.fillMode = .full
        starsSmak.settings.fillMode = .full
        starsZapach.settings.fillMode = .full
        starsTemp.settings.fillMode = .full
        starsIlosc.settings.fillMode = .full
        starsCena.settings.fillMode = .full
        starsOpis.settings.fillMode = .full
        starsZdjecie.settings.fillMode = .full
        starsCobytu.settings.fillMode = .full
        
    
        //----- wskaźnik aktywności-----------
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        //------------------------------------
        
        memory = StephencelisDB.instance.getMemory(memo: "mem_danie") //a:id dania, b:imageName, c: alergeny
        
        starsWyglad.didTouchCosmos = {rating in
            if self.starsWyglad.rating == 1 {self.ocenaLabel.text = "L_WYGLAD_NIE".localized()}
            if self.starsWyglad.rating == 2 {self.ocenaLabel.text = "L_WYGLAD_KIE".localized()}
            if self.starsWyglad.rating == 3 {self.ocenaLabel.text = "L_WYGLAD_POP".localized()}
            if self.starsWyglad.rating == 4 {self.ocenaLabel.text = "L_WYGLAD_APE".localized()}
            if self.starsWyglad.rating == 5 {self.ocenaLabel.text = "L_WYGLAD_REW".localized()}
        }
        
        starsWyglad.didFinishTouchingCosmos = {rating in
            if self.starsWyglad.rating == 1 {self.ocenaLabel.text = "L_WYGLAD_NIE".localized()}
            if self.starsWyglad.rating == 2 {self.ocenaLabel.text = "L_WYGLAD_KIE".localized()}
            if self.starsWyglad.rating == 3 {self.ocenaLabel.text = "L_WYGLAD_POP".localized()}
            if self.starsWyglad.rating == 4 {self.ocenaLabel.text = "L_WYGLAD_APE".localized()}
            if self.starsWyglad.rating == 5 {self.ocenaLabel.text = "L_WYGLAD_REW".localized()}
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                self.ocenaLabel.text = "L_OCENA_DANIA".localized()
            }
        }
        starsSmak.didTouchCosmos = {
            rating in
            if self.starsSmak.rating == 1 {self.ocenaLabel.text = "L_SMAK_TRA".localized()}
            if self.starsSmak.rating == 2 {self.ocenaLabel.text = "L_SMAK_NIE".localized()}
            if self.starsSmak.rating == 3 {self.ocenaLabel.text = "L_SMAK_NAT".localized()}
            if self.starsSmak.rating == 4 {self.ocenaLabel.text = "L_SMACZNE".localized()}
            if self.starsSmak.rating == 5 {self.ocenaLabel.text = "L_SMAKUJE_WYS".localized()}
        }
        
        starsSmak.didFinishTouchingCosmos = {rating in
            if self.starsSmak.rating == 1 {self.ocenaLabel.text = "L_SMAK_TRA".localized()}
            if self.starsSmak.rating == 2 {self.ocenaLabel.text = "L_SMAK_NIE".localized()}
            if self.starsSmak.rating == 3 {self.ocenaLabel.text = "L_SMAK_NAT".localized()}
            if self.starsSmak.rating == 4 {self.ocenaLabel.text = "L_SMACZNE".localized()}
            if self.starsSmak.rating == 5 {self.ocenaLabel.text = "L_SMAKUJE_WYS".localized()}
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                self.ocenaLabel.text = "L_OCENA_DANIA".localized()
            }
        }
        
        starsZapach.didTouchCosmos = {rating in
            if self.starsZapach.rating == 1 {self.ocenaLabel.text = "L_ZAPACH_TRA".localized()}
            if self.starsZapach.rating == 2 {self.ocenaLabel.text = "L_BRAK_ZAPACHU".localized()}
            if self.starsZapach.rating == 3 {self.ocenaLabel.text = "L_ZAPACH_NEU".localized()}
            if self.starsZapach.rating == 4 {self.ocenaLabel.text = "L_PRZYJEMNY_ZAPACH".localized()}
            if self.starsZapach.rating == 5 {self.ocenaLabel.text = "L_PACHNIE_REW".localized()}
        }
        
        starsZapach.didFinishTouchingCosmos = {rating in
            if self.starsZapach.rating == 1 {self.ocenaLabel.text = "L_ZAPACH_TRA".localized()}
            if self.starsZapach.rating == 2 {self.ocenaLabel.text = "L_BRAK_ZAPACHU".localized()}
            if self.starsZapach.rating == 3 {self.ocenaLabel.text = "L_ZAPACH_NEU".localized()}
            if self.starsZapach.rating == 4 {self.ocenaLabel.text = "L_PRZYJEMNY_ZAPACH".localized()}
            if self.starsZapach.rating == 5 {self.ocenaLabel.text = "L_PACHNIE_REW".localized()}
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                self.ocenaLabel.text = "L_OCENA_DANIA".localized()
            }
        }
        
        starsTemp.didTouchCosmos = {rating in
            if self.starsTemp.rating == 1 {self.ocenaLabel.text = "L_TEMP_NISKA".localized()}
            if self.starsTemp.rating == 2 {self.ocenaLabel.text = "L_TEMP_WYSOKA".localized()}
            if self.starsTemp.rating == 3 {self.ocenaLabel.text = "L_TEMP_DOBRA".localized()}
            if self.starsTemp.rating == 4 {self.ocenaLabel.text = "L_TEMP_ODPOWIEDNIA".localized()}
            if self.starsTemp.rating == 5 {self.ocenaLabel.text = "L_TEMP_IDEALNA".localized()}
        }
        
        starsTemp.didFinishTouchingCosmos = {rating in
            if self.starsTemp.rating == 1 {self.ocenaLabel.text = "L_TEMP_NISKA".localized()}
            if self.starsTemp.rating == 2 {self.ocenaLabel.text = "L_TEMP_WYSOKA".localized()}
            if self.starsTemp.rating == 3 {self.ocenaLabel.text = "L_TEMP_DOBRA".localized()}
            if self.starsTemp.rating == 4 {self.ocenaLabel.text = "L_TEMP_ODPOWIEDNIA".localized()}
            if self.starsTemp.rating == 5 {self.ocenaLabel.text = "L_TEMP_IDEALNA".localized()}
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                self.ocenaLabel.text = "L_OCENA_DANIA".localized()
            }
        }
        
        starsIlosc.didTouchCosmos = {rating in
            if self.starsIlosc.rating == 1 {self.ocenaLabel.text = "L_PORCJA_B_MALA".localized()}
            if self.starsIlosc.rating == 2 {self.ocenaLabel.text = "L_PORCJA_MALA".localized()}
            if self.starsIlosc.rating == 3 {self.ocenaLabel.text = "L_PORCJA_SREDNIA".localized()}
            if self.starsIlosc.rating == 4 {self.ocenaLabel.text = "L_PORCJA_WLASCIWA".localized()}
            if self.starsIlosc.rating == 5 {self.ocenaLabel.text = "L_PORCJA_DUZA".localized()}
        }
        
        starsIlosc.didFinishTouchingCosmos = {rating in
            if self.starsIlosc.rating == 1 {self.ocenaLabel.text = "L_PORCJA_B_MALA".localized()}
            if self.starsIlosc.rating == 2 {self.ocenaLabel.text = "L_PORCJA_MALA".localized()}
            if self.starsIlosc.rating == 3 {self.ocenaLabel.text = "L_PORCJA_SREDNIA".localized()}
            if self.starsIlosc.rating == 4 {self.ocenaLabel.text = "L_PORCJA_WLASCIWA".localized()}
            if self.starsIlosc.rating == 5 {self.ocenaLabel.text = "L_PORCJA_DUZA".localized()}
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                self.ocenaLabel.text = "L_OCENA_DANIA".localized()
            }
        }
        
        starsCena.didTouchCosmos = {rating in
            if self.starsCena.rating == 1 {self.ocenaLabel.text = "L_CENA_ZDE".localized()}
            if self.starsCena.rating == 2 {self.ocenaLabel.text = "L_CENA_TRO".localized()}
            if self.starsCena.rating == 3 {self.ocenaLabel.text = "L_CENA_WLA".localized()}
            if self.starsCena.rating == 4 {self.ocenaLabel.text = "L_TANIO".localized()}
            if self.starsCena.rating == 5 {self.ocenaLabel.text = "L_BARDZO_TANIO".localized()}
        }
    
        starsCena.didFinishTouchingCosmos = {rating in
            if self.starsCena.rating == 1 {self.ocenaLabel.text = "L_CENA_ZDE".localized()}
            if self.starsCena.rating == 2 {self.ocenaLabel.text = "L_CENA_TRO".localized()}
            if self.starsCena.rating == 3 {self.ocenaLabel.text = "L_CENA_WLA".localized()}
            if self.starsCena.rating == 4 {self.ocenaLabel.text = "L_TANIO".localized()}
            if self.starsCena.rating == 5 {self.ocenaLabel.text = "L_BARDZO_TANIO".localized()}
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                self.ocenaLabel.text = "L_OCENA_DANIA".localized()
            }
        }
        
        starsOpis.didTouchCosmos = {rating in
            if self.starsOpis.rating == 1 {self.ocenaLabel.text = "L_OPIS1".localized()}
            if self.starsOpis.rating == 2 {self.ocenaLabel.text = "L_OPIS2".localized()}
            if self.starsOpis.rating == 3 {self.ocenaLabel.text = "L_OPIS3".localized()}
            if self.starsOpis.rating == 4 {self.ocenaLabel.text = "L_OPIS4".localized()}
            if self.starsOpis.rating == 5 {self.ocenaLabel.text = "L_OPIS5".localized()}
        }
        
        starsOpis.didFinishTouchingCosmos = {rating in
            if self.starsOpis.rating == 1 {self.ocenaLabel.text = "L_OPIS1".localized()}
            if self.starsOpis.rating == 2 {self.ocenaLabel.text = "L_OPIS2".localized()}
            if self.starsOpis.rating == 3 {self.ocenaLabel.text = "L_OPIS3".localized()}
            if self.starsOpis.rating == 4 {self.ocenaLabel.text = "L_OPIS4".localized()}
            if self.starsOpis.rating == 5 {self.ocenaLabel.text = "L_OPIS5".localized()}
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                self.ocenaLabel.text = "L_OCENA_DANIA".localized()
            }
        }
        
        starsZdjecie.didTouchCosmos = {rating in
            if self.starsZdjecie.rating == 1 {self.ocenaLabel.text = "L_ZDJECIE_1".localized()}
            if self.starsZdjecie.rating == 2 {self.ocenaLabel.text = "L_ZDJECIE_2".localized()}
            if self.starsZdjecie.rating == 3 {self.ocenaLabel.text = "L_ZDJECIE_3".localized()}
            if self.starsZdjecie.rating == 4 {self.ocenaLabel.text = "L_ZDJECIE_4".localized()}
            if self.starsZdjecie.rating == 5 {self.ocenaLabel.text = "L_ZDJECIE_5".localized()}
        }
        
        starsZdjecie.didFinishTouchingCosmos = {rating in
            if self.starsZdjecie.rating == 1 {self.ocenaLabel.text = "L_ZDJECIE_1".localized()}
            if self.starsZdjecie.rating == 2 {self.ocenaLabel.text = "L_ZDJECIE_2".localized()}
            if self.starsZdjecie.rating == 3 {self.ocenaLabel.text = "L_ZDJECIE_3".localized()}
            if self.starsZdjecie.rating == 4 {self.ocenaLabel.text = "L_ZDJECIE_4".localized()}
            if self.starsZdjecie.rating == 5 {self.ocenaLabel.text = "L_ZDJECIE_5".localized()}
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                self.ocenaLabel.text = "L_OCENA_DANIA".localized()
            }
        }
        
        starsCobytu.didTouchCosmos = {rating in
            if self.starsCobytu.rating == 1 {self.ocenaLabel.text = "L_COBYTU_1".localized()}
            if self.starsCobytu.rating == 2 {self.ocenaLabel.text = "L_COBYTU_2".localized()}
            if self.starsCobytu.rating == 3 {self.ocenaLabel.text = "L_COBYTU_3".localized()}
            if self.starsCobytu.rating == 4 {self.ocenaLabel.text = "L_COBYTU_4".localized()}
            if self.starsCobytu.rating == 5 {self.ocenaLabel.text = "L_COBYTU_5".localized()}
        }
        
        starsCobytu.didFinishTouchingCosmos = {rating in
            if self.starsCobytu.rating == 1 {self.ocenaLabel.text = "L_COBYTU_1".localized()}
            if self.starsCobytu.rating == 2 {self.ocenaLabel.text = "L_COBYTU_2".localized()}
            if self.starsCobytu.rating == 3 {self.ocenaLabel.text = "L_COBYTU_3".localized()}
            if self.starsCobytu.rating == 4 {self.ocenaLabel.text = "L_COBYTU_4".localized()}
            if self.starsCobytu.rating == 5 {self.ocenaLabel.text = "L_COBYTU_5".localized()}
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                self.ocenaLabel.text = "L_OCENA_DANIA".localized()
            }
        }
        
    }
    
    //usuwanie klawiatury z ekranu po naciśnięciu "Return" (działa przez delegata textField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    //usuwanie klawiatury - funkcja ustawiana w Main.storybord - uruchomienie przez Touch Down
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    //funkcje naśladujace (imitujące) placeholder w textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "L_TRESC_OPINII".localized() {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "L_TRESC_OPINII".localized()
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc @IBAction private func zapisTapped() {
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            //----- wskaźnik aktywności-------
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            //---------------------------------
            
            let res = zapisz_opinie()
            
            if res == 1 {//jeżeli udało się zapisać zmiany na serwerze
                
                //opóźnienie bo downloadJSON_opinie nie zdąży pobrać i odświeżyć dnych
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                   
                    self.downloadJSON_opinie{
                        //zapamiętanie opinii o daniu w pamieci
                        Shared.shared.opinie = self.meal_opinie
                        
                        //zapamiętanie opinii zalogowanego
                        for moje in self.meal_opinie{
                            if moje.op_uz_id == Shared.shared.uz_id {
                                self.moje_meal_opinie.append(moje)
                            }
                        }
                        Shared.shared.moje_opinie =  self.moje_meal_opinie
                        
                        //----- wskaźnik aktywności-------
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        //---------------------------------
                        _ = self.navigationController?.popViewController(animated: true) //powrót
                    
                    }
                }
            }
        }else{ //jeżeli nie ma Internetu
            displayAlert()
        }
    }
    
    //----------------------------------------------------------
    //aktualizacja danych użytkownika na serwerze
    //----------------------------------------------------------
    func zapisz_opinie()  -> Int  {
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_opinia.php")
        var request = URLRequest(url: myUrl!)
        let autor = autorTextField.text
        let tytul = tytulTextField.text
        var tresc = textView.text
        //jeżeli treścią jest tekst placeholder (domyśny, wskazujący co wpisać w pole)
        if tresc == "L_TRESC_OPINII".localized() {
            tresc = ""
        }
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["op_id": "0", //nowa opinia
                          "op_da_id": self.memory![0].a,
                          "op_autor": autor!,
                          "op_uz_id": Shared.shared.uz_id,
                          "op_tytul": tytul!,
                          "op_tresc": tresc!,
                          "op_wyglad": String(starsWyglad.rating),
                          "op_smak": String(starsSmak.rating),
                          "op_zapach": String(starsZapach.rating),
                          "op_temp": String(starsTemp.rating),
                          "op_ilosc": String(starsIlosc.rating),
                          "op_cena": String(starsCena.rating),
                          "op_opis": String(starsOpis.rating),
                          "op_foto": String(starsZdjecie.rating),
                          "op_cobytu": String(starsCobytu.rating)] as! [String: String]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
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
                
                let success = String(describing: json!["success"])
                print("ss=\(success)")
                
                if (success != "Optional(1)"){
                    return
                }else{
                    //powiodło sie)
                    return
                }
            } catch{
                print(error)
            }
        }
        task.resume()
        return 1
    }
    
    //=====================================
    //komunikat "Brak Internetu"
    //=====================================
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
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


}

//potrzebne przy pogrubianiu tekstu godzin otwarcia
extension DodajOpinieViewController: UITextViewDelegate{
    
    func textViewDidChange (_ textView: UITextView){
        //print(textView.text)
        let size = CGSize(width: self.view.frame.width - 32, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach {(constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
