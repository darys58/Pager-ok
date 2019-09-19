//
//  NazwyViewController.swift
//  Pager
//
//  Created by darys on 04.05.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Localize_Swift

class NazwyCell: UITableViewCell{
  
    @IBOutlet weak var nazwaImage: UIImageView!
    @IBOutlet weak var nazwaLabel: UILabel!
    @IBOutlet weak var dalej1Button: UIButton!
    
    @IBOutlet weak var b01Button: UIButton!
    @IBOutlet weak var b02Button: UIButton!
    @IBOutlet weak var b03Button: UIButton!
    @IBOutlet weak var b04Button: UIButton!
    @IBOutlet weak var b05Button: UIButton!
    @IBOutlet weak var b06Button: UIButton!
    @IBOutlet weak var b07Button: UIButton!
    @IBOutlet weak var b08Button: UIButton!
    @IBOutlet weak var b09Button: UIButton!
    @IBOutlet weak var b10Button: UIButton!
}

class NazwyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var reachability: Reachability?  //dostępność Internetu
    var activityIndicator = UIActivityIndicatorView()
    var rodzajSkladnika = [RodzajSk]()      //dane z JSONa - kategorie składników pobrane z www
    var nazwaSkladnika = [NazwaSk]()      //dane z JSONa - nazwy składników pobrane z www
    var formaSkladnika = [FormaSk]()      //dane z JSONa - formy składników pobrane z www
    
    @IBOutlet weak var tableViewNazwy: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewNazwy.estimatedRowHeight = 110
        tableViewNazwy.rowHeight = UITableViewAutomaticDimension
        
        let titlelabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel1
        titlelabel1.text = Shared.shared.rd_rodzaj
        titlelabel1.textAlignment = .center
       
        //pobranie kategorii składników z bazy lokalnej i zapisane ich w pamięci podręcznej
        Shared.shared.nazwy = StephencelisDB.instance.getNazwy()
        
        //----- wskaźnik aktywności-----------
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        //------------------------------------
    }

    override func viewWillAppear(_ animated: Bool) {
        //pobranie nazw składników z bazy lokalnej i zapisane ich w pamięci podręcznej
        //przeniesione tutaj z viewDidLoad żeby działało po powrocie z form
        Shared.shared.nazwy = StephencelisDB.instance.getNazwy()
        
        //odświeżenie listy nazw po powrocie z form
        self.tableViewNazwy.reloadData() //reloadRows(at: [[0, 0]], with: .none)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shared.shared.nazwy.count
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NazwyCell", for: indexPath) as? NazwyCell else {
                fatalError("Komórka nie jest instancją NazwyCell")
            }
                //żeby nie znikało tło pod napisami po wybraniu celi
                cell.selectionStyle = UITableViewCellSelectionStyle.none
    
                //ikona rodzaju składników
                switch Shared.shared.rd_id{
                    case 1: cell.nazwaImage.image = UIImage(named: "ryby")
                    case 2: cell.nazwaImage.image = UIImage(named: "miesa")
                    case 5: cell.nazwaImage.image = UIImage(named: "napoje")
                    case 6: cell.nazwaImage.image = UIImage(named: "alkohole")
                    case 7: cell.nazwaImage.image = UIImage(named: "drob")
                    case 8: cell.nazwaImage.image = UIImage(named: "wieprzowina")
                    case 9: cell.nazwaImage.image = UIImage(named: "wolowina")
                    case 12: cell.nazwaImage.image = UIImage(named: "warzywa")
                    case 13: cell.nazwaImage.image = UIImage(named: "maczne")
                    case 14: cell.nazwaImage.image = UIImage(named: "morskie")
                    case 15: cell.nazwaImage.image = UIImage(named: "slodkie")
                    case 16: cell.nazwaImage.image = UIImage(named: "nabial")
                    case 17: cell.nazwaImage.image = UIImage(named: "owoce")
                    case 18: cell.nazwaImage.image = UIImage(named: "wedliny")
                    case 19: cell.nazwaImage.image = UIImage(named: "grzyby")
                    case 21: cell.nazwaImage.image = UIImage(named: "przyprawy")
                    default: cell.nazwaImage.image = UIImage(named: "alkohole")
                }

                //nazwa składnika
                if Shared.shared.nazwy[indexPath.row].nd_do_oceny > 0{
                    cell.nazwaLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
                }else{
                    cell.nazwaLabel.font = UIFont.systemFont(ofSize: 18.0)
                }
                cell.nazwaLabel.text = "\(Shared.shared.nazwy[indexPath.row].nd_nazwa) (\(Shared.shared.nazwy[indexPath.row].nd_total)/\(Shared.shared.nazwy[indexPath.row].nd_do_oceny))"
    
                //przycisk dalej
                cell.dalej1Button.tag = indexPath.row
                cell.dalej1Button.addTarget(self, action: #selector(self.przejdzDoForm), for: .touchUpInside)

                //buźki
                cell.b01Button.tag = indexPath.row
                if Shared.shared.nazwy[indexPath.row].no01 == 1{
                    cell.b01Button.setImage(UIImage(named: "k_01"), for: .normal)
                }else{ cell.b01Button.setImage(UIImage(named: "sz_01"), for: .normal)}
                cell.b01Button.addTarget(self, action: #selector(self.buzia01), for: .touchUpInside)
 
                cell.b02Button.tag = indexPath.row
                if Shared.shared.nazwy[indexPath.row].no02 == 1{
                    cell.b02Button.setImage(UIImage(named: "k_02"), for: .normal)
                }else{ cell.b02Button.setImage(UIImage(named: "sz_02"), for: .normal)}
                cell.b02Button.addTarget(self, action: #selector(self.buzia02), for: .touchUpInside)
    
                cell.b03Button.tag = indexPath.row
                if Shared.shared.nazwy[indexPath.row].no03 == 1{
                    cell.b03Button.setImage(UIImage(named: "k_03"), for: .normal)
                }else{ cell.b03Button.setImage(UIImage(named: "sz_03"), for: .normal)}
                cell.b03Button.addTarget(self, action: #selector(self.buzia03), for: .touchUpInside)

                cell.b04Button.tag = indexPath.row
                if Shared.shared.nazwy[indexPath.row].no04 == 1{
                    cell.b04Button.setImage(UIImage(named: "k_04"), for: .normal)
                }else{ cell.b04Button.setImage(UIImage(named: "sz_04"), for: .normal)}
                cell.b04Button.addTarget(self, action: #selector(self.buzia04), for: .touchUpInside)
    
                cell.b05Button.tag = indexPath.row
                if Shared.shared.nazwy[indexPath.row].no05 == 1{
                    cell.b05Button.setImage(UIImage(named: "k_05"), for: .normal)
                }else{ cell.b05Button.setImage(UIImage(named: "sz_05"), for: .normal)}
                cell.b05Button.addTarget(self, action: #selector(self.buzia05), for: .touchUpInside)
    
                cell.b06Button.tag = indexPath.row
                if Shared.shared.nazwy[indexPath.row].no06 == 1{
                    cell.b06Button.setImage(UIImage(named: "k_06"), for: .normal)
                }else{ cell.b06Button.setImage(UIImage(named: "sz_06"), for: .normal)}
                cell.b06Button.addTarget(self, action: #selector(self.buzia06), for: .touchUpInside)

                cell.b07Button.tag = indexPath.row
                if Shared.shared.nazwy[indexPath.row].no07 == 1{
                    cell.b07Button.setImage(UIImage(named: "k_07"), for: .normal)
                }else{ cell.b07Button.setImage(UIImage(named: "sz_07"), for: .normal)}
                cell.b07Button.addTarget(self, action: #selector(self.buzia07), for: .touchUpInside)
    
                cell.b08Button.tag = indexPath.row
                if Shared.shared.nazwy[indexPath.row].no08 == 1{
                    cell.b08Button.setImage(UIImage(named: "k_08"), for: .normal)
                }else{ cell.b08Button.setImage(UIImage(named: "sz_08"), for: .normal)}
                cell.b08Button.addTarget(self, action: #selector(self.buzia08), for: .touchUpInside)
    
                cell.b09Button.tag = indexPath.row
                if Shared.shared.nazwy[indexPath.row].no09 == 1{
                    cell.b09Button.setImage(UIImage(named: "k_09"), for: .normal)
                }else{ cell.b09Button.setImage(UIImage(named: "sz_09"), for: .normal)}
                cell.b09Button.addTarget(self, action: #selector(self.buzia09), for: .touchUpInside)
    
                cell.b10Button.tag = indexPath.row
                if Shared.shared.nazwy[indexPath.row].no10 == 1{
                    cell.b10Button.setImage(UIImage(named: "k_10"), for: .normal)
                }else{ cell.b10Button.setImage(UIImage(named: "sz_10"), for: .normal)}
                cell.b10Button.addTarget(self, action: #selector(self.buzia10), for: .touchUpInside)
    
        return cell
    }

 // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 //       return 110
 //   }

    
    //--------------------------------------------------------
    //przejście do listy form składników w wybranej nazwie
    //--------------------------------------------------------
    @IBAction func przejdzDoForm(_ sender: UIButton) {
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            //----- wskaźnik aktywności-------
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            //---------------------------------
            
            Shared.shared.nd_id = Shared.shared.nazwy[sender.tag].nd_id
            Shared.shared.nd_nazwa = Shared.shared.nazwy[sender.tag].nd_nazwa

            //skasowanie wszystkich form skladników z tabeli 'formy'
            _ = StephencelisDB.instance.deleteFormyAll()
            
            //pobranie form składników
            self.downloadJSON_formy{
                print(self.formaSkladnika)
                //zapisanie form składników do bazy lokalnej 'formy'
                for fom in self.formaSkladnika {
                    _ = StephencelisDB.instance.addFormy(fdid: fom.fd_id, forma: fom.fd_forma, doid: fom.do_id, dokcal: fom.do_kcal100, udlubi: fom.ud_lubi)
                }
                
                self.performSegue(withIdentifier: "sbFormySkladnikow", sender: self) //przejście do NazwyViewController (w tym miejscu bo jest ok dopiero po pobraniu danych z serwera)
                //----- wskaźnik aktywności-------
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                //---------------------------------
            }
        }else{ //jeżeli nie ma Internetu
            displayAlert()
        }
        
    }
    
   

    @IBAction func buzia01(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_NAZWY".localized() + " '\(Shared.shared.nazwy[sender.tag].nd_nazwa)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.nazwy[sender.tag].nd_total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_SZKODZI_MI".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                //nic
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.nazwy[sender.tag].no01 = 1
                Shared.shared.nazwy[sender.tag].no02 = 0
                Shared.shared.nazwy[sender.tag].no03 = 0
                Shared.shared.nazwy[sender.tag].no04 = 0
                Shared.shared.nazwy[sender.tag].no05 = 0
                Shared.shared.nazwy[sender.tag].no06 = 0
                Shared.shared.nazwy[sender.tag].no07 = 0
                Shared.shared.nazwy[sender.tag].no08 = 0
                Shared.shared.nazwy[sender.tag].no09 = 0
                Shared.shared.nazwy[sender.tag].no10 = 0
                Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
                
                //update ocenionej nazwy na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "1", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną nazwą
                    self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej nazwy w bazie lokalnej
                    _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 1, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
             //   }
                    //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.nazwy[sender.tag].no01 = 1
            Shared.shared.nazwy[sender.tag].no02 = 0
            Shared.shared.nazwy[sender.tag].no03 = 0
            Shared.shared.nazwy[sender.tag].no04 = 0
            Shared.shared.nazwy[sender.tag].no05 = 0
            Shared.shared.nazwy[sender.tag].no06 = 0
            Shared.shared.nazwy[sender.tag].no07 = 0
            Shared.shared.nazwy[sender.tag].no08 = 0
            Shared.shared.nazwy[sender.tag].no09 = 0
            Shared.shared.nazwy[sender.tag].no10 = 0
            Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
            
            //update ocenionej kategorii na serwerze cobytu.com
            let res = self.aktualizujSkladnik(ud_lubi: "1", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
            if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                //odświeżenie celi z ocenioną nazwą
                self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                //update ocenionej nazwy w bazie lokalnej
                _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 1, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
                
                //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
    }

    @IBAction func buzia02(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_NAZWY".localized() + " '\(Shared.shared.nazwy[sender.tag].nd_nazwa)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.nazwy[sender.tag].nd_total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_NIENAWIDZE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.nazwy[sender.tag].no01 = 0
                Shared.shared.nazwy[sender.tag].no02 = 1
                Shared.shared.nazwy[sender.tag].no03 = 0
                Shared.shared.nazwy[sender.tag].no04 = 0
                Shared.shared.nazwy[sender.tag].no05 = 0
                Shared.shared.nazwy[sender.tag].no06 = 0
                Shared.shared.nazwy[sender.tag].no07 = 0
                Shared.shared.nazwy[sender.tag].no08 = 0
                Shared.shared.nazwy[sender.tag].no09 = 0
                Shared.shared.nazwy[sender.tag].no10 = 0
                Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
                
                //update ocenionej nazwy na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "2", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną nazwą
                    self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej nazwy w bazie lokalnej
                    _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 1, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
                    
                    //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.nazwy[sender.tag].no01 = 0
            Shared.shared.nazwy[sender.tag].no02 = 1
            Shared.shared.nazwy[sender.tag].no03 = 0
            Shared.shared.nazwy[sender.tag].no04 = 0
            Shared.shared.nazwy[sender.tag].no05 = 0
            Shared.shared.nazwy[sender.tag].no06 = 0
            Shared.shared.nazwy[sender.tag].no07 = 0
            Shared.shared.nazwy[sender.tag].no08 = 0
            Shared.shared.nazwy[sender.tag].no09 = 0
            Shared.shared.nazwy[sender.tag].no10 = 0
            Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
            
            //update ocenionej kategorii na serwerze cobytu.com
            let res = self.aktualizujSkladnik(ud_lubi: "2", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
            if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                //odświeżenie celi z ocenioną nazwą
                self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                //update ocenionej nazwy w bazie lokalnej
                _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 1, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
            
                //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
    }
    
    @IBAction func buzia03(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_NAZWY".localized() + " '\(Shared.shared.nazwy[sender.tag].nd_nazwa)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.nazwy[sender.tag].nd_total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_NIE_LUBIE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.nazwy[sender.tag].no01 = 0
                Shared.shared.nazwy[sender.tag].no02 = 0
                Shared.shared.nazwy[sender.tag].no03 = 1
                Shared.shared.nazwy[sender.tag].no04 = 0
                Shared.shared.nazwy[sender.tag].no05 = 0
                Shared.shared.nazwy[sender.tag].no06 = 0
                Shared.shared.nazwy[sender.tag].no07 = 0
                Shared.shared.nazwy[sender.tag].no08 = 0
                Shared.shared.nazwy[sender.tag].no09 = 0
                Shared.shared.nazwy[sender.tag].no10 = 0
                Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
                
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "3", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną nazwą
                    self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej nazwy w bazie lokalnej
                    _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 1, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
                    
                    //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.nazwy[sender.tag].no01 = 0
            Shared.shared.nazwy[sender.tag].no02 = 0
            Shared.shared.nazwy[sender.tag].no03 = 1
            Shared.shared.nazwy[sender.tag].no04 = 0
            Shared.shared.nazwy[sender.tag].no05 = 0
            Shared.shared.nazwy[sender.tag].no06 = 0
            Shared.shared.nazwy[sender.tag].no07 = 0
            Shared.shared.nazwy[sender.tag].no08 = 0
            Shared.shared.nazwy[sender.tag].no09 = 0
            Shared.shared.nazwy[sender.tag].no10 = 0
            Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
            
            //update ocenionej kategorii na serwerze cobytu.com
            let res = self.aktualizujSkladnik(ud_lubi: "3", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
            if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                //odświeżenie celi z ocenioną nazwą
                self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                //update ocenionej nazwy w bazie lokalnej
                _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 1, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
                
                //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
    }
    
    @IBAction func buzia04(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_NAZWY".localized() + " '\(Shared.shared.nazwy[sender.tag].nd_nazwa)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.nazwy[sender.tag].nd_total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_NIECHETNIE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.nazwy[sender.tag].no01 = 0
                Shared.shared.nazwy[sender.tag].no02 = 0
                Shared.shared.nazwy[sender.tag].no03 = 0
                Shared.shared.nazwy[sender.tag].no04 = 1
                Shared.shared.nazwy[sender.tag].no05 = 0
                Shared.shared.nazwy[sender.tag].no06 = 0
                Shared.shared.nazwy[sender.tag].no07 = 0
                Shared.shared.nazwy[sender.tag].no08 = 0
                Shared.shared.nazwy[sender.tag].no09 = 0
                Shared.shared.nazwy[sender.tag].no10 = 0
                Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
                
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "4", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną nazwą
                    self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej nazwy w bazie lokalnej
                    _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 1, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
                    
                    //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.nazwy[sender.tag].no01 = 0
            Shared.shared.nazwy[sender.tag].no02 = 0
            Shared.shared.nazwy[sender.tag].no03 = 0
            Shared.shared.nazwy[sender.tag].no04 = 1
            Shared.shared.nazwy[sender.tag].no05 = 0
            Shared.shared.nazwy[sender.tag].no06 = 0
            Shared.shared.nazwy[sender.tag].no07 = 0
            Shared.shared.nazwy[sender.tag].no08 = 0
            Shared.shared.nazwy[sender.tag].no09 = 0
            Shared.shared.nazwy[sender.tag].no10 = 0
            Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
            
            //update ocenionej kategorii na serwerze cobytu.com
            let res = self.aktualizujSkladnik(ud_lubi: "4", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
            if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                //odświeżenie celi z ocenioną nazwą
                self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                //update ocenionej nazwy w bazie lokalnej
                _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 1, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
                
                //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
    }
    @IBAction func buzia05(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_NAZWY".localized() + " '\(Shared.shared.nazwy[sender.tag].nd_nazwa)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.nazwy[sender.tag].nd_total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_BEZ_EMOCJI".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.nazwy[sender.tag].no01 = 0
                Shared.shared.nazwy[sender.tag].no02 = 0
                Shared.shared.nazwy[sender.tag].no03 = 0
                Shared.shared.nazwy[sender.tag].no04 = 0
                Shared.shared.nazwy[sender.tag].no05 = 1
                Shared.shared.nazwy[sender.tag].no06 = 0
                Shared.shared.nazwy[sender.tag].no07 = 0
                Shared.shared.nazwy[sender.tag].no08 = 0
                Shared.shared.nazwy[sender.tag].no09 = 0
                Shared.shared.nazwy[sender.tag].no10 = 0
                Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
                
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "5", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną nazwą
                    self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej nazwy w bazie lokalnej
                    _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 1, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
                    //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.nazwy[sender.tag].no01 = 0
            Shared.shared.nazwy[sender.tag].no02 = 0
            Shared.shared.nazwy[sender.tag].no03 = 0
            Shared.shared.nazwy[sender.tag].no04 = 0
            Shared.shared.nazwy[sender.tag].no05 = 1
            Shared.shared.nazwy[sender.tag].no06 = 0
            Shared.shared.nazwy[sender.tag].no07 = 0
            Shared.shared.nazwy[sender.tag].no08 = 0
            Shared.shared.nazwy[sender.tag].no09 = 0
            Shared.shared.nazwy[sender.tag].no10 = 0
            Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
            
            //update ocenionej kategorii na serwerze cobytu.com
            let res = self.aktualizujSkladnik(ud_lubi: "5", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
            if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                //odświeżenie celi z ocenioną nazwą
                self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                //update ocenionej nazwy w bazie lokalnej
                _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 1, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
                
                //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
    }
    @IBAction func buzia06(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_NAZWY".localized() + " '\(Shared.shared.nazwy[sender.tag].nd_nazwa)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.nazwy[sender.tag].nd_total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_MOGE_SPROBOWAC".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.nazwy[sender.tag].no01 = 0
                Shared.shared.nazwy[sender.tag].no02 = 0
                Shared.shared.nazwy[sender.tag].no03 = 0
                Shared.shared.nazwy[sender.tag].no04 = 0
                Shared.shared.nazwy[sender.tag].no05 = 0
                Shared.shared.nazwy[sender.tag].no06 = 1
                Shared.shared.nazwy[sender.tag].no07 = 0
                Shared.shared.nazwy[sender.tag].no08 = 0
                Shared.shared.nazwy[sender.tag].no09 = 0
                Shared.shared.nazwy[sender.tag].no10 = 0
                Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
                
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "6", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną nazwą
                    self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej nazwy w bazie lokalnej
                    _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 1, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
                    
                    //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.nazwy[sender.tag].no01 = 0
            Shared.shared.nazwy[sender.tag].no02 = 0
            Shared.shared.nazwy[sender.tag].no03 = 0
            Shared.shared.nazwy[sender.tag].no04 = 0
            Shared.shared.nazwy[sender.tag].no05 = 0
            Shared.shared.nazwy[sender.tag].no06 = 1
            Shared.shared.nazwy[sender.tag].no07 = 0
            Shared.shared.nazwy[sender.tag].no08 = 0
            Shared.shared.nazwy[sender.tag].no09 = 0
            Shared.shared.nazwy[sender.tag].no10 = 0
            Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
            
            //update ocenionej kategorii na serwerze cobytu.com
            let res = self.aktualizujSkladnik(ud_lubi: "6", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
            if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                //odświeżenie celi z ocenioną nazwą
                self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                //update ocenionej nazwy w bazie lokalnej
                _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 1, b07: 0, b08: 0, b09: 0, b10: 0, ndocena: 1)
                
                //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
    }
    @IBAction func buzia07(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_NAZWY".localized() + " '\(Shared.shared.nazwy[sender.tag].nd_nazwa)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.nazwy[sender.tag].nd_total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_CHETNIE_SPROBUJE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.nazwy[sender.tag].no01 = 0
                Shared.shared.nazwy[sender.tag].no02 = 0
                Shared.shared.nazwy[sender.tag].no03 = 0
                Shared.shared.nazwy[sender.tag].no04 = 0
                Shared.shared.nazwy[sender.tag].no05 = 0
                Shared.shared.nazwy[sender.tag].no06 = 0
                Shared.shared.nazwy[sender.tag].no07 = 1
                Shared.shared.nazwy[sender.tag].no08 = 0
                Shared.shared.nazwy[sender.tag].no09 = 0
                Shared.shared.nazwy[sender.tag].no10 = 0
                Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
                
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "7", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną nazwą
                    self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej nazwy w bazie lokalnej
                    _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 1, b08: 0, b09: 0, b10: 0, ndocena: 1)
                    //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.nazwy[sender.tag].no01 = 0
            Shared.shared.nazwy[sender.tag].no02 = 0
            Shared.shared.nazwy[sender.tag].no03 = 0
            Shared.shared.nazwy[sender.tag].no04 = 0
            Shared.shared.nazwy[sender.tag].no05 = 0
            Shared.shared.nazwy[sender.tag].no06 = 0
            Shared.shared.nazwy[sender.tag].no07 = 1
            Shared.shared.nazwy[sender.tag].no08 = 0
            Shared.shared.nazwy[sender.tag].no09 = 0
            Shared.shared.nazwy[sender.tag].no10 = 0
            Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
            //update ocenionej kategorii na serwerze cobytu.com
            let res = self.aktualizujSkladnik(ud_lubi: "7", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
            if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                //odświeżenie celi z ocenioną nazwą
                self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                //update ocenionej nazwy w bazie lokalnej
                _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 1, b08: 0, b09: 0, b10: 0, ndocena: 1)
                
                //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
    }
    @IBAction func buzia08(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_NAZWY".localized() + " '\(Shared.shared.nazwy[sender.tag].nd_nazwa)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.nazwy[sender.tag].nd_total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_LUBIE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.nazwy[sender.tag].no01 = 0
                Shared.shared.nazwy[sender.tag].no02 = 0
                Shared.shared.nazwy[sender.tag].no03 = 0
                Shared.shared.nazwy[sender.tag].no04 = 0
                Shared.shared.nazwy[sender.tag].no05 = 0
                Shared.shared.nazwy[sender.tag].no06 = 0
                Shared.shared.nazwy[sender.tag].no07 = 0
                Shared.shared.nazwy[sender.tag].no08 = 1
                Shared.shared.nazwy[sender.tag].no09 = 0
                Shared.shared.nazwy[sender.tag].no10 = 0
                Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
                
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "8", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną nazwą
                    self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej nazwy w bazie lokalnej
                    _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 1, b09: 0, b10: 0, ndocena: 1)
                    
                    //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.nazwy[sender.tag].no01 = 0
            Shared.shared.nazwy[sender.tag].no02 = 0
            Shared.shared.nazwy[sender.tag].no03 = 0
            Shared.shared.nazwy[sender.tag].no04 = 0
            Shared.shared.nazwy[sender.tag].no05 = 0
            Shared.shared.nazwy[sender.tag].no06 = 0
            Shared.shared.nazwy[sender.tag].no07 = 0
            Shared.shared.nazwy[sender.tag].no08 = 1
            Shared.shared.nazwy[sender.tag].no09 = 0
            Shared.shared.nazwy[sender.tag].no10 = 0
            Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
            
            //update ocenionej kategorii na serwerze cobytu.com
            let res = self.aktualizujSkladnik(ud_lubi: "8", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
            if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                //odświeżenie celi z ocenioną nazwą
                self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                //update ocenionej nazwy w bazie lokalnej
                _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 1, b09: 0, b10: 0, ndocena: 1)
                
                //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
    }
    @IBAction func buzia09(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_NAZWY".localized() + " '\(Shared.shared.nazwy[sender.tag].nd_nazwa)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.nazwy[sender.tag].nd_total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_BARDZO_LUBIE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.nazwy[sender.tag].no01 = 0
                Shared.shared.nazwy[sender.tag].no02 = 0
                Shared.shared.nazwy[sender.tag].no03 = 0
                Shared.shared.nazwy[sender.tag].no04 = 0
                Shared.shared.nazwy[sender.tag].no05 = 0
                Shared.shared.nazwy[sender.tag].no06 = 0
                Shared.shared.nazwy[sender.tag].no07 = 0
                Shared.shared.nazwy[sender.tag].no08 = 0
                Shared.shared.nazwy[sender.tag].no09 = 1
                Shared.shared.nazwy[sender.tag].no10 = 0
                Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
                
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "9", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną nazwą
                    self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej nazwy w bazie lokalnej
                    _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 1, b10: 0, ndocena: 1)
                    
                    //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.nazwy[sender.tag].no01 = 0
            Shared.shared.nazwy[sender.tag].no02 = 0
            Shared.shared.nazwy[sender.tag].no03 = 0
            Shared.shared.nazwy[sender.tag].no04 = 0
            Shared.shared.nazwy[sender.tag].no05 = 0
            Shared.shared.nazwy[sender.tag].no06 = 0
            Shared.shared.nazwy[sender.tag].no07 = 0
            Shared.shared.nazwy[sender.tag].no08 = 0
            Shared.shared.nazwy[sender.tag].no09 = 1
            Shared.shared.nazwy[sender.tag].no10 = 0
            Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
            
            //update ocenionej kategorii na serwerze cobytu.com
            let res = self.aktualizujSkladnik(ud_lubi: "9", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
            if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                //odświeżenie celi z ocenioną nazwą
                self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                //update ocenionej nazwy w bazie lokalnej
                _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 1, b10: 0, ndocena: 1)
                
                //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
    }
    @IBAction func buzia10(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_NAZWY".localized() + " '\(Shared.shared.nazwy[sender.tag].nd_nazwa)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.nazwy[sender.tag].nd_total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_UWIELBIAM".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.nazwy[sender.tag].no01 = 0
                Shared.shared.nazwy[sender.tag].no02 = 0
                Shared.shared.nazwy[sender.tag].no03 = 0
                Shared.shared.nazwy[sender.tag].no04 = 0
                Shared.shared.nazwy[sender.tag].no05 = 0
                Shared.shared.nazwy[sender.tag].no06 = 0
                Shared.shared.nazwy[sender.tag].no07 = 0
                Shared.shared.nazwy[sender.tag].no08 = 0
                Shared.shared.nazwy[sender.tag].no09 = 0
                Shared.shared.nazwy[sender.tag].no10 = 1
                Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
                
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "10", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną nazwą
                    self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej nazwy w bazie lokalnej
                    _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 1, ndocena: 1)
                    
                    //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.nazwy[sender.tag].no01 = 0
            Shared.shared.nazwy[sender.tag].no02 = 0
            Shared.shared.nazwy[sender.tag].no03 = 0
            Shared.shared.nazwy[sender.tag].no04 = 0
            Shared.shared.nazwy[sender.tag].no05 = 0
            Shared.shared.nazwy[sender.tag].no06 = 0
            Shared.shared.nazwy[sender.tag].no07 = 0
            Shared.shared.nazwy[sender.tag].no08 = 0
            Shared.shared.nazwy[sender.tag].no09 = 0
            Shared.shared.nazwy[sender.tag].no10 = 1
            Shared.shared.nazwy[sender.tag].nd_do_oceny = 0
            
            //update ocenionej kategorii na serwerze cobytu.com
            let res = self.aktualizujSkladnik(ud_lubi: "10", rd_id: String(Shared.shared.rd_id), nd_id: String(Shared.shared.nazwy[sender.tag].nd_id))
            if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                //odświeżenie celi z ocenioną nazwą
                self.tableViewNazwy.reloadRows(at: [[0, sender.tag]], with: .none)
                //update ocenionej nazwy w bazie lokalnej
                _ = StephencelisDB.instance.updateNazwy(ndid: Shared.shared.nazwy[sender.tag].nd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 1, ndocena: 1)
                
                //pobranie kategorii składników bo została zmieniona ocena nazwy (można by to robić raz po  wybraniu powrotu z nazw do rodzajów ale nie wiem jak !!!!!)
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
    }
    
  
    
    
    //----------------------------------------------------------
    //aktualizacja ocenianej nazwy składników na serwerze
    //----------------------------------------------------------
    func aktualizujSkladnik(ud_lubi: String, rd_id: String, nd_id: String)  -> Int  {
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_lubi_do.php")
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["do_id": "0",
                          "ud_lubi": ud_lubi,
                          "uz_id": Shared.shared.uz_id,
                          "rd_id": rd_id,
                          "nd_id": nd_id] as [String: String]
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
    
    //=========================================================
    //funkcja pobierająca JSONa z formami składników
    //=========================================================
    func downloadJSON_formy(completed: @escaping () -> ()) {
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_formy_do&uz_id=\(Shared.shared.uz_id!)&rd=\(Shared.shared.rd_id!)&nd=\(Shared.shared.nd_id!)&lang=\(Localize.currentLanguage())")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            //print("do form = ")
            if error == nil{
                do {
                    // print(data)
                    self.formaSkladnika = try JSONDecoder().decode([FormaSk].self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print ("JSON Error")
                }
            }
        }.resume()
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
    
}
