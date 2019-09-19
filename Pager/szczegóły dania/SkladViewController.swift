//
//  SkladViewController.swift
//  Pager
//
//  Created by darys on 01.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Localize_Swift

class SkladViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var alergenTextView: UITextView!
    @IBOutlet weak var skladTableView: UITableView!
    
    var meal_sklad = [MealSklad]()
    var rodzajSkladnika = [RodzajSk]()      //dane z JSONa - kategorie składników pobrane z www
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meal_sklad = Shared.shared.sklad
       
        alergenTextView.layer.cornerRadius = 10
        
        var alergeny = "L_ALERGENY".localized() + ": "
        
        if Shared.shared.alergeny.isEmpty{  //wszystkie alergeny w daniu
          alergeny += "L_BRAK".localized()
        //alergeny += "L_PO_ZALOGOWANIU".localized()
        }else{
            var i = 0
            for al in Shared.shared.alergeny {
                alergeny += al
                i += 1
                if i != Shared.shared.alergeny.count{
                  alergeny += ", "
                }         
            }
        }
        alergenTextView.text = alergeny
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meal_sklad.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Shared.shared.uz_id! != "" { //dla zalogowanego
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkladTableViewCell", for: indexPath) as! SkladTableViewCell

            cell.nazwaLabel.text = self.meal_sklad[indexPath.row].nd_nazwa
            cell.formaLabel.text = self.meal_sklad[indexPath.row].fd_forma
            cell.kcalLabel.text = "\(self.meal_sklad[indexPath.row].do_kcal100) " + "L_KCAL".localized() + "/100" + "L_G".localized()
            
            //lubienie
            switch self.meal_sklad[indexPath.row].ud_lubi{
                case "1": cell.lubiLabel.text = "L_SZKODZI_MI".localized()
                case "2": cell.lubiLabel.text = "L_NIENAWIDZE".localized()
                case "3": cell.lubiLabel.text = "L_NIE_LUBIE".localized()
                case "4": cell.lubiLabel.text = "L_NIECHETNIE".localized()
                case "5": cell.lubiLabel.text = "L_BEZ_EMOCJI".localized()
                case "6": cell.lubiLabel.text = "L_MOGE_SPROBOWAC".localized()
                case "7": cell.lubiLabel.text = "L_CHETNIE_SPROBUJE".localized()
                case "8": cell.lubiLabel.text = "L_LUBIE".localized()
                case "9": cell.lubiLabel.text = "L_BARDZO_LUBIE".localized()
                case "10": cell.lubiLabel.text = "L_UWIELBIAM".localized()
                default:  cell.lubiLabel.text = "brak oceny"
            }
            
            //buźki
            cell.b01Button.tag = indexPath.row
            if meal_sklad[indexPath.row].ud_lubi == "1"{
                cell.b01Button.setImage(UIImage(named: "k_01"), for: .normal)
            }else{ cell.b01Button.setImage(UIImage(named: "sz_01"), for: .normal)}
            cell.b01Button.addTarget(self, action: #selector(self.buzia01), for: .touchUpInside)
            
            cell.b02Button.tag = indexPath.row
            if meal_sklad[indexPath.row].ud_lubi == "2"{
                cell.b02Button.setImage(UIImage(named: "k_02"), for: .normal)
            }else{ cell.b02Button.setImage(UIImage(named: "sz_02"), for: .normal)}
            cell.b02Button.addTarget(self, action: #selector(self.buzia02), for: .touchUpInside)
            
            cell.b03Button.tag = indexPath.row
            if meal_sklad[indexPath.row].ud_lubi == "3"{
                cell.b03Button.setImage(UIImage(named: "k_03"), for: .normal)
            }else{ cell.b03Button.setImage(UIImage(named: "sz_03"), for: .normal)}
            cell.b03Button.addTarget(self, action: #selector(self.buzia03), for: .touchUpInside)
            
            cell.b04Button.tag = indexPath.row
            if meal_sklad[indexPath.row].ud_lubi == "4"{
                cell.b04Button.setImage(UIImage(named: "k_04"), for: .normal)
            }else{ cell.b04Button.setImage(UIImage(named: "sz_04"), for: .normal)}
            cell.b04Button.addTarget(self, action: #selector(self.buzia04), for: .touchUpInside)
            
            cell.b05Button.tag = indexPath.row
            if meal_sklad[indexPath.row].ud_lubi == "5"{
                cell.b05Button.setImage(UIImage(named: "k_05"), for: .normal)
            }else{ cell.b05Button.setImage(UIImage(named: "sz_05"), for: .normal)}
            cell.b05Button.addTarget(self, action: #selector(self.buzia05), for: .touchUpInside)
            
            cell.b06Button.tag = indexPath.row
            if meal_sklad[indexPath.row].ud_lubi == "6"{
                cell.b06Button.setImage(UIImage(named: "k_06"), for: .normal)
            }else{ cell.b06Button.setImage(UIImage(named: "sz_06"), for: .normal)}
            cell.b06Button.addTarget(self, action: #selector(self.buzia06), for: .touchUpInside)
            
            cell.b07Button.tag = indexPath.row
            if meal_sklad[indexPath.row].ud_lubi == "7"{
                cell.b07Button.setImage(UIImage(named: "k_07"), for: .normal)
            }else{ cell.b07Button.setImage(UIImage(named: "sz_07"), for: .normal)}
            cell.b07Button.addTarget(self, action: #selector(self.buzia07), for: .touchUpInside)
            
            cell.b08Button.tag = indexPath.row
            if meal_sklad[indexPath.row].ud_lubi == "8"{
                cell.b08Button.setImage(UIImage(named: "k_08"), for: .normal)
            }else{ cell.b08Button.setImage(UIImage(named: "sz_08"), for: .normal)}
            cell.b08Button.addTarget(self, action: #selector(self.buzia08), for: .touchUpInside)
            
            cell.b09Button.tag = indexPath.row
            if meal_sklad[indexPath.row].ud_lubi == "9"{
                cell.b09Button.setImage(UIImage(named: "k_09"), for: .normal)
            }else{ cell.b09Button.setImage(UIImage(named: "sz_09"), for: .normal)}
            cell.b09Button.addTarget(self, action: #selector(self.buzia09), for: .touchUpInside)
            
            cell.b10Button.tag = indexPath.row
            if meal_sklad[indexPath.row].ud_lubi == "10"{
                cell.b10Button.setImage(UIImage(named: "k_10"), for: .normal)
            }else{ cell.b10Button.setImage(UIImage(named: "sz_10"), for: .normal)}
            cell.b10Button.addTarget(self, action: #selector(self.buzia10), for: .touchUpInside)
            
            return cell
        
        }else { //dla niezalogowanego
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkladTableViewCell1", for: indexPath) as! SkladTableViewCell1
            
            cell.nazwaLabel.text = self.meal_sklad[indexPath.row].nd_nazwa
            cell.formaLabel.text = self.meal_sklad[indexPath.row].fd_forma
            cell.kcalLabel.text = "\(self.meal_sklad[indexPath.row].do_kcal100) " + "L_KCAL".localized() + "/100" + "L_G".localized()
            
            return cell
        }
        
    }
    
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Shared.shared.uz_id! != "" {
            return 95
        }else{
            return 60
        }
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "L_SKLADNIKI_DANIA".localized() + ":"
    }


    @IBAction func buzia01(_ sender: UIButton) {
        //update w pamięci podręcznej
        Shared.shared.sklad[sender.tag].ud_lubi = "1"
        meal_sklad[sender.tag].ud_lubi = "1"
        
        //update ocenionego składnika na serwerze cobytu.com
        let res = self.aktualizujSkladnik(ud_lubi: "1", rd_id: meal_sklad[sender.tag].do_rd_id, do_id: meal_sklad[sender.tag].do_id)
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z ocenioną nazwą
            self.skladTableView.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //aktualizacja kategorii - pobranie kategorii składników z serwera
            self.downloadJSON_rodzaje{
                //skasowanie wszystkich kategorii składników
                _ = StephencelisDB.instance.deleteRodzajeAll()
                //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                for rodz in self.rodzajSkladnika {
                    _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                }
            }
        }
    }

    @IBAction func buzia02(_ sender: UIButton) {
        //update w pamięci podręcznej
        Shared.shared.sklad[sender.tag].ud_lubi = "2"
        meal_sklad[sender.tag].ud_lubi = "2"
        
        //update ocenionego składnika na serwerze cobytu.com
        let res = self.aktualizujSkladnik(ud_lubi: "2", rd_id: meal_sklad[sender.tag].do_rd_id, do_id: meal_sklad[sender.tag].do_id)
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z ocenioną nazwą
            self.skladTableView.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //aktualizacja kategorii - pobranie kategorii składników z serwera
            self.downloadJSON_rodzaje{
                //skasowanie wszystkich kategorii składników
                _ = StephencelisDB.instance.deleteRodzajeAll()
                //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                for rodz in self.rodzajSkladnika {
                    _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                }
            }
        }
    }
    
    @IBAction func buzia03(_ sender: UIButton) {
        //update w pamięci podręcznej
        Shared.shared.sklad[sender.tag].ud_lubi = "3"
        meal_sklad[sender.tag].ud_lubi = "3"
        
        //update ocenionego składnika na serwerze cobytu.com
        let res = self.aktualizujSkladnik(ud_lubi: "3", rd_id: meal_sklad[sender.tag].do_rd_id, do_id: meal_sklad[sender.tag].do_id)
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z ocenioną nazwą
            self.skladTableView.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //aktualizacja kategorii - pobranie kategorii składników z serwera
            self.downloadJSON_rodzaje{
                //skasowanie wszystkich kategorii składników
                _ = StephencelisDB.instance.deleteRodzajeAll()
                //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                for rodz in self.rodzajSkladnika {
                    _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                }
            }
        }
    }
    
    @IBAction func buzia04(_ sender: UIButton) {
        //update w pamięci podręcznej
        Shared.shared.sklad[sender.tag].ud_lubi = "4"
        meal_sklad[sender.tag].ud_lubi = "4"
        
        //update ocenionego składnika na serwerze cobytu.com
        let res = self.aktualizujSkladnik(ud_lubi: "4", rd_id: meal_sklad[sender.tag].do_rd_id, do_id: meal_sklad[sender.tag].do_id)
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z ocenioną nazwą
            self.skladTableView.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //aktualizacja kategorii - pobranie kategorii składników z serwera
            self.downloadJSON_rodzaje{
                //skasowanie wszystkich kategorii składników
                _ = StephencelisDB.instance.deleteRodzajeAll()
                //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                for rodz in self.rodzajSkladnika {
                    _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                }
            }
        }
    }
    
    @IBAction func buzia05(_ sender: UIButton) {
        //update w pamięci podręcznej
        Shared.shared.sklad[sender.tag].ud_lubi = "5"
        meal_sklad[sender.tag].ud_lubi = "5"
        
        //update ocenionego składnika na serwerze cobytu.com
        let res = self.aktualizujSkladnik(ud_lubi: "5", rd_id: meal_sklad[sender.tag].do_rd_id, do_id: meal_sklad[sender.tag].do_id)
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z ocenioną nazwą
            self.skladTableView.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //aktualizacja kategorii - pobranie kategorii składników z serwera
            self.downloadJSON_rodzaje{
                //skasowanie wszystkich kategorii składników
                _ = StephencelisDB.instance.deleteRodzajeAll()
                //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                for rodz in self.rodzajSkladnika {
                    _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                }
            }
        }
    }
    
    @IBAction func buzia06(_ sender: UIButton) {
        //update w pamięci podręcznej
        Shared.shared.sklad[sender.tag].ud_lubi = "6"
        meal_sklad[sender.tag].ud_lubi = "6"
        
        //update ocenionego składnika na serwerze cobytu.com
        let res = self.aktualizujSkladnik(ud_lubi: "6", rd_id: meal_sklad[sender.tag].do_rd_id, do_id: meal_sklad[sender.tag].do_id)
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z ocenioną nazwą
            self.skladTableView.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //aktualizacja kategorii - pobranie kategorii składników z serwera
            self.downloadJSON_rodzaje{
                //skasowanie wszystkich kategorii składników
                _ = StephencelisDB.instance.deleteRodzajeAll()
                //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                for rodz in self.rodzajSkladnika {
                    _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                }
            }
        }
    }
    
    @IBAction func buzia07(_ sender: UIButton) {
        //update w pamięci podręcznej
        Shared.shared.sklad[sender.tag].ud_lubi = "7"
        meal_sklad[sender.tag].ud_lubi = "7"
        
        //update ocenionego składnika na serwerze cobytu.com
        let res = self.aktualizujSkladnik(ud_lubi: "7", rd_id: meal_sklad[sender.tag].do_rd_id, do_id: meal_sklad[sender.tag].do_id)
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z ocenioną nazwą
            self.skladTableView.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //aktualizacja kategorii - pobranie kategorii składników z serwera
            self.downloadJSON_rodzaje{
                //skasowanie wszystkich kategorii składników
                _ = StephencelisDB.instance.deleteRodzajeAll()
                //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                for rodz in self.rodzajSkladnika {
                    _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                }
            }
        }
    }
    
    @IBAction func buzia08(_ sender: UIButton) {
        //update w pamięci podręcznej
        Shared.shared.sklad[sender.tag].ud_lubi = "8"
        meal_sklad[sender.tag].ud_lubi = "8"
        
        //update ocenionego składnika na serwerze cobytu.com
        let res = self.aktualizujSkladnik(ud_lubi: "8", rd_id: meal_sklad[sender.tag].do_rd_id, do_id: meal_sklad[sender.tag].do_id)
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z ocenioną nazwą
            self.skladTableView.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //aktualizacja kategorii - pobranie kategorii składników z serwera
            self.downloadJSON_rodzaje{
                //skasowanie wszystkich kategorii składników
                _ = StephencelisDB.instance.deleteRodzajeAll()
                //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                for rodz in self.rodzajSkladnika {
                    _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                }
            }
        }
    }
    
    @IBAction func buzia09(_ sender: UIButton) {
        //update w pamięci podręcznej
        Shared.shared.sklad[sender.tag].ud_lubi = "9"
        meal_sklad[sender.tag].ud_lubi = "9"
        
        //update ocenionego składnika na serwerze cobytu.com
        let res = self.aktualizujSkladnik(ud_lubi: "9", rd_id: meal_sklad[sender.tag].do_rd_id, do_id: meal_sklad[sender.tag].do_id)
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z ocenioną nazwą
            self.skladTableView.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //aktualizacja kategorii - pobranie kategorii składników z serwera
            self.downloadJSON_rodzaje{
                //skasowanie wszystkich kategorii składników
                _ = StephencelisDB.instance.deleteRodzajeAll()
                //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                for rodz in self.rodzajSkladnika {
                    _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                }
            }
        }
    }
    @IBAction func buzia10(_ sender: UIButton) {
        //update w pamięci podręcznej
        Shared.shared.sklad[sender.tag].ud_lubi = "10"
        meal_sklad[sender.tag].ud_lubi = "10"
        
        //update ocenionego składnika na serwerze cobytu.com
        let res = self.aktualizujSkladnik(ud_lubi: "10", rd_id: meal_sklad[sender.tag].do_rd_id, do_id: meal_sklad[sender.tag].do_id)
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z ocenioną nazwą
            self.skladTableView.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //aktualizacja kategorii - pobranie kategorii składników z serwera
            self.downloadJSON_rodzaje{
                //skasowanie wszystkich kategorii składników
                _ = StephencelisDB.instance.deleteRodzajeAll()
                //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                for rodz in self.rodzajSkladnika {
                    _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                }
            }
        }
    }
    //----------------------------------------------------------
    //aktualizacja ocenianej nazwy składników na serwerze
    //----------------------------------------------------------
    func aktualizujSkladnik(ud_lubi: String, rd_id: String, do_id: String)  -> Int  {
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_lubi_do.php")
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["do_id": do_id,
                          "ud_lubi": ud_lubi,
                          "uz_id": Shared.shared.uz_id,
                          "rd_id": rd_id,
                          "nd_id": "0"] as [String: String]
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
                
                let success = String(describing: json!["success"])
                print("ss=\(success)")
                
                if (success != "Optional(1)"){
                    return
                }else{
                    //powiodło sie)
                    AppDelegate.lubienie_zmienione = true //zmieniono ocenę składników
                    AppDelegate.refresh_list_meal = true //trzeba odświerzyć listę dań
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
