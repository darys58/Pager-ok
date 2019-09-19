//
//  MojeOpinieViewController.swift
//  Pager
//
//  Created by darys on 01.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Cosmos
import Localize_Swift

class MojeOpinieCell: UITableViewCell {
    
    
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var sredniaLabel: UILabel!
    @IBOutlet weak var dodanoLabel: UILabel!
    @IBOutlet weak var tytulLabel: UILabel!
    @IBOutlet weak var opiniaTextView: UITextView!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var edytujButton: UIButton!
    @IBOutlet weak var usunButton: UIButton!
}

class MojeOpinieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var reachability: Reachability?  //dostępność Internetu
    var activityIndicator = UIActivityIndicatorView()
    var memory: [Memorydb]? = []        //id dania zapamiętane w bazie lokalnej
    var meal_opinie = [MealOpinie]()
    var ile_opinii = 0
    var moje_meal_opinie = [MealOpinie]()    //dane z JSONa - opinie o daniu
    
    @IBOutlet weak var opinieTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opinieTableView.estimatedRowHeight = 175
        opinieTableView.rowHeight = UITableViewAutomaticDimension
        
        if Shared.shared.moje_opinie.isEmpty {
            ile_opinii = 0
        }else{
            meal_opinie = Shared.shared.moje_opinie
            ile_opinii = meal_opinie.count
        }
        
        memory = StephencelisDB.instance.getMemory(memo: "mem_danie") //a:id dania, b:imageName, c: alergeny
        
        //----- wskaźnik aktywności-----------
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        //------------------------------------
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        meal_opinie = Shared.shared.moje_opinie  //przepisanie z pamięci podręcznej do zmiennej
        ile_opinii = meal_opinie.count
        self.opinieTableView.reloadData()
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ile_opinii
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MojeOpinieCell", for: indexPath) as! MojeOpinieCell
        cell.starsView.rating = Double(self.meal_opinie[indexPath.row].op_srednia)!
        cell.autorLabel.text = self.meal_opinie[indexPath.row].op_autor
        cell.sredniaLabel.text = self.meal_opinie[indexPath.row].op_srednia
        cell.dodanoLabel.text = self.meal_opinie[indexPath.row].op_data_dod
        cell.tytulLabel.text = self.meal_opinie[indexPath.row].op_tytul
        //cell.trescTextView.text = self.meal_opinie[indexPath.row].op_tresc
        
        var opinia = ""
        switch self.meal_opinie[indexPath.row].op_wyglad{
            case "1": opinia += "L_WYGLAD_NIE".localized() + ". "
            case "2": opinia += "L_WYGLAD_KIE".localized() + ". "
            case "3": opinia += "L_WYGLAD_POP".localized() + ". "
            case "4": opinia += "L_WYGLAD_APE".localized() + ". "
            case "5": opinia += "L_WYGLAD_REW".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_smak{
            case "1": opinia += "L_SMAK_TRA".localized() + ". "
            case "2": opinia += "L_SMAK_NIE".localized() + ". "
            case "3": opinia += "L_SMAK_NAT".localized() + ". "
            case "4": opinia += "L_SMACZNE".localized() + ". "
            case "5": opinia += "L_SMAKUJE_WYS".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_zapach{
            case "1": opinia += "L_ZAPACH_TRA".localized() + ". "
            case "2": opinia += "L_BRAK_ZAPACHU".localized() + ". "
            case "3": opinia += "L_ZAPACH_NEU".localized() + ". "
            case "4": opinia += "L_PRZYJEMNY_ZAPACH".localized() + ". "
            case "5": opinia += "L_PACHNIE_REW".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_temp{
            case "1": opinia += "L_TEMP_NISKA".localized() + ". "
            case "2": opinia += "L_TEMP_WYSOKA".localized() + ". "
            case "3": opinia += "L_TEMP_DOBRA".localized() + ". "
            case "4": opinia += "L_TEMP_ODPOWIEDNIA".localized() + ". "
            case "5": opinia += "L_TEMP_IDEALNA".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_ilosc{
            case "1": opinia += "L_PORCJA_B_MALA".localized() + ". "
            case "2": opinia += "L_PORCJA_MALA".localized() + ". "
            case "3": opinia += "L_PORCJA_SREDNIA".localized() + ". "
            case "4": opinia += "L_PORCJA_WLASCIWA".localized() + ". "
            case "5": opinia += "L_PORCJA_DUZA".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_cena{
            case "1": opinia += "L_CENA_ZDE".localized() + ". "
            case "2": opinia += "L_CENA_TRO".localized() + ". "
            case "3": opinia += "L_CENA_WLA".localized() + ". "
            case "4": opinia += "L_TANIO".localized() + ". "
            case "5": opinia += "L_BARDZO_TANIO".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_opis{
            case "1": opinia += "L_OPIS1".localized() + ". "
            case "2": opinia += "L_OPIS2".localized() + ". "
            case "3": opinia += "L_OPIS3".localized() + ". "
            case "4": opinia += "L_OPIS4".localized() + ". "
            case "5": opinia += "L_OPIS5".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_foto{
            case "1": opinia += "L_ZDJECIE_1".localized() + ". "
            case "2": opinia += "L_ZDJECIE_2".localized() + ". "
            case "3": opinia += "L_ZDJECIE_3".localized() + ". "
            case "4": opinia += "L_ZDJECIE_4".localized() + ". "
            case "5": opinia += "L_ZDJECIE_5".localized() + ". "
        default: opinia += ""
        }
        if self.meal_opinie[indexPath.row].op_tresc == "" {
            cell.opiniaTextView.text = opinia
        }else {
            cell.opiniaTextView.text = self.meal_opinie[indexPath.row].op_tresc + " \n \(opinia)"
        }
        
        cell.edytujButton.tag = indexPath.row
        cell.edytujButton.setTitle("L_EDYTUJ".localized(), for: .normal)
        
        cell.usunButton.tag = indexPath.row
        cell.usunButton.setTitle("L_USUN".localized(), for: .normal)
        
        return cell
    }
    
    //---------------
    //edycja opinii
    //---------------
    @IBAction func wybrano_edytuj(_ sender: UIButton) {
        Shared.shared.moja_opinia = self.meal_opinie[sender.tag]
        performSegue(withIdentifier: "sbEdytujOpinie", sender: self) //przejście
    }
    
    //---------------
    //usuwanie opinii
    //---------------
    @IBAction func wybrano_usun(_ sender: UIButton) {
        let alertController = UIAlertController(title: "L_POTWIERDZENIE".localized(), message: "L_CZY_USUNAC".localized() + " '", preferredStyle: .alert)
        
        let CancelAction = UIAlertAction(title: "L_NIE".localized(), style: .default){
            (action:UIAlertAction!) in
            print ("Anuluj")
        }
        let OKAction = UIAlertAction(title: "L_TAK".localized(), style: .default){
            (action:UIAlertAction!) in
            
            self.reachability = Reachability.init()
            if((self.reachability!.connection) != .none){ //jeżeli jest Internet
                //----- wskaźnik aktywności-------
                self.activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                //---------------------------------
                
                let res = self.usun_opinie(id_opinii: self.meal_opinie[sender.tag].op_id )
                
                if res == 1 {//jeżeli udało się zapisać zmiany na serwerze
                    
                    //opóźnienie bo downloadJSON_opinie nie zdąży pobrać i odświeżyć dnych
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        
                        self.downloadJSON_opinie{
                            //zapamiętanie opinii o daniu w pamieci
                            Shared.shared.opinie = self.meal_opinie
                            
                            //zerowanie tablicy
                            self.moje_meal_opinie.removeAll()
                            
                            //zapamiętanie opinii zalogowanego
                            for moje in self.meal_opinie{
                                if moje.op_uz_id == Shared.shared.uz_id {
                                    self.moje_meal_opinie.append(moje)
                                }
                            }
                            //aktualizacja moje_opinie
                            Shared.shared.moje_opinie =  self.moje_meal_opinie
                            
                            //----- wskaźnik aktywności-------
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            //---------------------------------
                           // _ = self.navigationController?.popViewController(animated: true) //powrót
                            self.meal_opinie = Shared.shared.moje_opinie  //przepisanie z pamięci podręcznej do zmiennej
                            self.ile_opinii = self.meal_opinie.count
                            self.opinieTableView.reloadData()
                        }
                    }
                }
            }else{ //jeżeli nie ma Internetu
                self.displayAlert()
            }
        
        
        }
        alertController.addAction(CancelAction)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //----------------------------------------------------------
    //aktualizacja danych użytkownika na serwerze
    //----------------------------------------------------------
    func usun_opinie(id_opinii: String)  -> Int  {
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_opinia.php")
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = ["op_id": id_opinii, //id opinii
                          "op_cobytu": "9.9"] // wartość "9.9" oznacza usunięcie opinii w skrypcie php
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

    
    
    //komunikat "Brak Internetu"
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "L_MOJE_OPINIE_0_DANIU".localized() + ":"
    }
    // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //     return 180
    //}
}


