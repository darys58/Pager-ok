//
//  RodzajeViewController.swift
//  Pager
//
//  Created by darys on 04.05.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Localize_Swift

class RodzajeCell: UITableViewCell{
  
    @IBOutlet weak var rodzajImage: UIImageView!
    @IBOutlet weak var rodzajLabel: UILabel!
    @IBOutlet weak var dalejButton: UIButton!
    
    
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

class RodzajeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var reachability: Reachability?  //dostępność Internetu
    var activityIndicator = UIActivityIndicatorView()
    var rodzajSkladnika = [RodzajSk]()      //dane z JSONa - kategorie składników pobrane z www
    var nazwaSkladnika = [NazwaSk]()      //dane z JSONa - nazwy składników pobrane z www
    var formaSkladnika = [FormaSk]()      //dane z JSONa - składniki startowe pobrane z www
    
    @IBOutlet weak var tableWiewRodzaje: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableWiewRodzaje.estimatedRowHeight = 110
        tableWiewRodzaje.rowHeight = UITableViewAutomaticDimension
        
        
        let titlelabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel1
        titlelabel1.textAlignment = .center
        titlelabel1.text = "L_JAK_LUBISZ".localized()
        
        //----- wskaźnik aktywności-----------
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        //------------------------------------
    
    }

    override func viewWillAppear(_ animated: Bool) {
        //pobranie kategorii składników z bazy lokalnej i zapisane ich w pamięci podręcznej
        //przeniesione tutaj z viewDidLoad żeby działało po powrocie z nazw
        Shared.shared.rodzaje = StephencelisDB.instance.getRodzaje()

        //odświeżenie listy kategorii po powrocie z nazw
        self.tableWiewRodzaje.reloadData() //reloadRows(at: [[0, 0]], with: .none)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shared.shared.rodzaje.count
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RodzajeCell", for: indexPath) as? RodzajeCell else {
                fatalError("Komórka nie jest instancją RodzajeCell")
            }
                //żeby nie znikało tło pod napisami po wybraniu celi
                cell.selectionStyle = UITableViewCellSelectionStyle.none
    
                //ikona rodzaju składników
                switch Shared.shared.rodzaje[indexPath.row].rd_id{
                    case 1: cell.rodzajImage.image = UIImage(named: "ryby")
                    case 2: cell.rodzajImage.image = UIImage(named: "miesa")
                    case 5: cell.rodzajImage.image = UIImage(named: "napoje")
                    case 6: cell.rodzajImage.image = UIImage(named: "alkohole")
                    case 7: cell.rodzajImage.image = UIImage(named: "drob")
                    case 8: cell.rodzajImage.image = UIImage(named: "wieprzowina")
                    case 9: cell.rodzajImage.image = UIImage(named: "wolowina")
                    case 12: cell.rodzajImage.image = UIImage(named: "warzywa")
                    case 13: cell.rodzajImage.image = UIImage(named: "maczne")
                    case 14: cell.rodzajImage.image = UIImage(named: "morskie")
                    case 15: cell.rodzajImage.image = UIImage(named: "slodkie")
                    case 16: cell.rodzajImage.image = UIImage(named: "nabial")
                    case 17: cell.rodzajImage.image = UIImage(named: "owoce")
                    case 18: cell.rodzajImage.image = UIImage(named: "wedliny")
                    case 19: cell.rodzajImage.image = UIImage(named: "grzyby")
                    case 21: cell.rodzajImage.image = UIImage(named: "przyprawy")
                    //kategorie startowe...
                    case 10: cell.rodzajImage.image = UIImage(named: "wieprzowina")
                    case 20: cell.rodzajImage.image = UIImage(named: "maczne")
                    case 30: cell.rodzajImage.image = UIImage(named: "warzywa")
                    case 40: cell.rodzajImage.image = UIImage(named: "nabial")
                    case 50: cell.rodzajImage.image = UIImage(named: "napoje")
                    case 60: cell.rodzajImage.image = UIImage(named: "przyprawy")
                    default: cell.rodzajImage.image = UIImage(named: "alkohole")
                }

                //nazwa rodzaju/kategorii
                if Shared.shared.rodzaje[indexPath.row].do_oceny > 0{
                    cell.rodzajLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
                }else{
                    cell.rodzajLabel.font = UIFont.systemFont(ofSize: 18.0)
                }
                cell.rodzajLabel.text = "\(Shared.shared.rodzaje[indexPath.row].rd_rodzaj) (\(Shared.shared.rodzaje[indexPath.row].total)/\(Shared.shared.rodzaje[indexPath.row].do_oceny))"
    
                //przycisk dalej
                cell.dalejButton.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].rd_id % 10 > 0 {//przejście do nazw normalnych
                    print("do nazw")
                    cell.dalejButton.addTarget(self, action: #selector(self.przejdzDoNazw), for: .touchUpInside)
                }else{//przejcie do nazw startowych
                    print("do startowych")
                    cell.dalejButton.addTarget(self, action: #selector(self.przejdzDoStartowych), for: .touchUpInside)
                }
    
                //buźki
                cell.b01Button.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].o01 == 1{
                    cell.b01Button.setImage(UIImage(named: "k_01"), for: .normal)
                }else{ cell.b01Button.setImage(UIImage(named: "sz_01"), for: .normal)}
                cell.b01Button.addTarget(self, action: #selector(self.buzia01), for: .touchUpInside)
    
                cell.b02Button.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].o02 == 1{
                    cell.b02Button.setImage(UIImage(named: "k_02"), for: .normal)
                }else{ cell.b02Button.setImage(UIImage(named: "sz_02"), for: .normal)}
                cell.b02Button.addTarget(self, action: #selector(self.buzia02), for: .touchUpInside)
    
                cell.b03Button.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].o03 == 1{
                    cell.b03Button.setImage(UIImage(named: "k_03"), for: .normal)
                }else{ cell.b03Button.setImage(UIImage(named: "sz_03"), for: .normal)}
                cell.b03Button.addTarget(self, action: #selector(self.buzia03), for: .touchUpInside)

                cell.b04Button.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].o04 == 1{
                    cell.b04Button.setImage(UIImage(named: "k_04"), for: .normal)
                }else{ cell.b04Button.setImage(UIImage(named: "sz_04"), for: .normal)}
                cell.b04Button.addTarget(self, action: #selector(self.buzia04), for: .touchUpInside)
    
                cell.b05Button.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].o05 == 1{
                    cell.b05Button.setImage(UIImage(named: "k_05"), for: .normal)
                }else{ cell.b05Button.setImage(UIImage(named: "sz_05"), for: .normal)}
                cell.b05Button.addTarget(self, action: #selector(self.buzia05), for: .touchUpInside)
    
                cell.b06Button.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].o06 == 1{
                    cell.b06Button.setImage(UIImage(named: "k_06"), for: .normal)
                }else{ cell.b06Button.setImage(UIImage(named: "sz_06"), for: .normal)}
                cell.b06Button.addTarget(self, action: #selector(self.buzia06), for: .touchUpInside)

                cell.b07Button.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].o07 == 1{
                    cell.b07Button.setImage(UIImage(named: "k_07"), for: .normal)
                }else{ cell.b07Button.setImage(UIImage(named: "sz_07"), for: .normal)}
                cell.b07Button.addTarget(self, action: #selector(self.buzia07), for: .touchUpInside)
    
                cell.b08Button.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].o08 == 1{
                    cell.b08Button.setImage(UIImage(named: "k_08"), for: .normal)
                }else{ cell.b08Button.setImage(UIImage(named: "sz_08"), for: .normal)}
                cell.b08Button.addTarget(self, action: #selector(self.buzia08), for: .touchUpInside)
    
                cell.b09Button.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].o09 == 1{
                    cell.b09Button.setImage(UIImage(named: "k_09"), for: .normal)
                }else{ cell.b09Button.setImage(UIImage(named: "sz_09"), for: .normal)}
                cell.b09Button.addTarget(self, action: #selector(self.buzia09), for: .touchUpInside)
    
                cell.b10Button.tag = indexPath.row
                if Shared.shared.rodzaje[indexPath.row].o10 == 1{
                    cell.b10Button.setImage(UIImage(named: "k_10"), for: .normal)
                }else{ cell.b10Button.setImage(UIImage(named: "sz_10"), for: .normal)}
                cell.b10Button.addTarget(self, action: #selector(self.buzia10), for: .touchUpInside)
    
        return cell
    }

  //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //      return 110
  //  }
    
    //--------------------------------------------------------
    //przejście do listy nazw składników w wybranej kategorii
    //--------------------------------------------------------
    @IBAction func przejdzDoNazw(_ sender: UIButton) {
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            //----- wskaźnik aktywności-------
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            //---------------------------------
            
            Shared.shared.rd_id = Shared.shared.rodzaje[sender.tag].rd_id
            Shared.shared.rd_rodzaj = Shared.shared.rodzaje[sender.tag].rd_rodzaj
            
            //skasowanie wszystkich nazw skladników z tabeli 'nazwy'
            _ = StephencelisDB.instance.deleteNazwyAll()
            
            //pobranie nazw składników
            self.downloadJSON_nazwy{
     //           print("nazwy składników")
     //           print(self.nazwaSkladnika)
                //zapisanie nazw składników do bazy lokalnej 'nazwy'
                for naz in self.nazwaSkladnika {
                    _ = StephencelisDB.instance.addNazwy(ndid: naz.nd_id, nazwa: naz.nd_nazwa, tot: naz.nd_total, dooceny: naz.nd_do_oceny, b01: naz.no01, b02: naz.no02, b03: naz.no03, b04: naz.no04, b05: naz.no05, b06: naz.no06, b07: naz.no07, b08: naz.no08, b09: naz.no09, b10: naz.no10, ndocena: naz.nd_ocena)
                }
            
               self.performSegue(withIdentifier: "sbNazwySkladnikow", sender: self) //przejście do NazwyViewController (w tym miejscu bo jest ok dopiero po pobraniu danych z serwera)
                
                //----- wskaźnik aktywności-------
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                //---------------------------------
            }
        }else{ //jeżeli nie ma Internetu
            displayAlert()
        }
    }
    
    //--------------------------------------------------------
    //przejście do listy nazw składników startowych w wybranej kategorii (zrobione na FormyViewController)
    //--------------------------------------------------------
    @IBAction func przejdzDoStartowych(_ sender: UIButton) {
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            //----- wskaźnik aktywności-------
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            //---------------------------------
            
        
            Shared.shared.rd_id = Shared.shared.rodzaje[sender.tag].rd_id
            Shared.shared.rd_rodzaj = Shared.shared.rodzaje[sender.tag].rd_rodzaj
            
            //skasowanie wszystkich form skladników z tabeli 'formy'
            _ = StephencelisDB.instance.deleteFormyAll()
            //pobranie nazw składników startowych
            self.downloadJSON_formy_nazwyStartowe{
                //print(self.formaSkladnika)
                //zapisanie form składników do bazy lokalnej 'formy'
                for fom in self.formaSkladnika {
                    _ = StephencelisDB.instance.addFormy(fdid: fom.fd_id, forma: fom.fd_forma, doid: fom.do_id, dokcal: fom.do_kcal100, udlubi: fom.ud_lubi)
                }
        
                self.performSegue(withIdentifier: "sbSkladnikiStartowe", sender: self) //przejście do NazwyViewController (w tym miejscu bo jest ok dopiero po pobraniu danych z serwera)
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
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_KATEGORIE".localized() + " '\(Shared.shared.rodzaje[sender.tag].rd_rodzaj)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.rodzaje[sender.tag].total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_SZKODZI_MI".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                //nic
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.rodzaje[sender.tag].o01 = 1
                Shared.shared.rodzaje[sender.tag].o02 = 0
                Shared.shared.rodzaje[sender.tag].o03 = 0
                Shared.shared.rodzaje[sender.tag].o04 = 0
                Shared.shared.rodzaje[sender.tag].o05 = 0
                Shared.shared.rodzaje[sender.tag].o06 = 0
                Shared.shared.rodzaje[sender.tag].o07 = 0
                Shared.shared.rodzaje[sender.tag].o08 = 0
                Shared.shared.rodzaje[sender.tag].o09 = 0
                Shared.shared.rodzaje[sender.tag].o10 = 0
                Shared.shared.rodzaje[sender.tag].do_oceny = 0
                
                if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                    //update ocenionej kategorii na serwerze cobytu.com
                    let res = self.aktualizujSkladnik(ud_lubi: "1", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 1, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }else{ //dla kategorii startowych
                    //update ocenionej kategorii startowej na serwerze cobytu.com
                     let res = self.aktualizujStartowe(us_lubi: "1", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 1, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.rodzaje[sender.tag].o01 = 1
            Shared.shared.rodzaje[sender.tag].o02 = 0
            Shared.shared.rodzaje[sender.tag].o03 = 0
            Shared.shared.rodzaje[sender.tag].o04 = 0
            Shared.shared.rodzaje[sender.tag].o05 = 0
            Shared.shared.rodzaje[sender.tag].o06 = 0
            Shared.shared.rodzaje[sender.tag].o07 = 0
            Shared.shared.rodzaje[sender.tag].o08 = 0
            Shared.shared.rodzaje[sender.tag].o09 = 0
            Shared.shared.rodzaje[sender.tag].o10 = 0
            Shared.shared.rodzaje[sender.tag].do_oceny = 0
            
            if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "1", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 1, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }else{ //dla kategorii startowych
                //update ocenionej kategorii startowej na serwerze cobytu.com
                let res = self.aktualizujStartowe(us_lubi: "1", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 1, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }
        }
    }
    
    @IBAction func buzia02(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_KATEGORIE".localized() + " '\(Shared.shared.rodzaje[sender.tag].rd_rodzaj)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.rodzaje[sender.tag].total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_NIENAWIDZE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.rodzaje[sender.tag].o01 = 0
                Shared.shared.rodzaje[sender.tag].o02 = 1
                Shared.shared.rodzaje[sender.tag].o03 = 0
                Shared.shared.rodzaje[sender.tag].o04 = 0
                Shared.shared.rodzaje[sender.tag].o05 = 0
                Shared.shared.rodzaje[sender.tag].o06 = 0
                Shared.shared.rodzaje[sender.tag].o07 = 0
                Shared.shared.rodzaje[sender.tag].o08 = 0
                Shared.shared.rodzaje[sender.tag].o09 = 0
                Shared.shared.rodzaje[sender.tag].o10 = 0
                Shared.shared.rodzaje[sender.tag].do_oceny = 0
                
                if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                    //update ocenionej kategorii na serwerze cobytu.com
                    let res = self.aktualizujSkladnik(ud_lubi: "2", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 1, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }else{ //dla kategorii startowych
                    //update ocenionej kategorii startowej na serwerze cobytu.com
                    let res = self.aktualizujStartowe(us_lubi: "2", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 1, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }
                
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.rodzaje[sender.tag].o01 = 0
            Shared.shared.rodzaje[sender.tag].o02 = 1
            Shared.shared.rodzaje[sender.tag].o03 = 0
            Shared.shared.rodzaje[sender.tag].o04 = 0
            Shared.shared.rodzaje[sender.tag].o05 = 0
            Shared.shared.rodzaje[sender.tag].o06 = 0
            Shared.shared.rodzaje[sender.tag].o07 = 0
            Shared.shared.rodzaje[sender.tag].o08 = 0
            Shared.shared.rodzaje[sender.tag].o09 = 0
            Shared.shared.rodzaje[sender.tag].o10 = 0
            Shared.shared.rodzaje[sender.tag].do_oceny = 0
            
            if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "2", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 1, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }else{ //dla kategorii startowych
                //update ocenionej kategorii startowej na serwerze cobytu.com
                let res = self.aktualizujStartowe(us_lubi: "2", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 1, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }
        }
    }
    
    @IBAction func buzia03(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_KATEGORIE".localized() + " '\(Shared.shared.rodzaje[sender.tag].rd_rodzaj)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.rodzaje[sender.tag].total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_NIE_LUBIE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.rodzaje[sender.tag].o01 = 0
                Shared.shared.rodzaje[sender.tag].o02 = 0
                Shared.shared.rodzaje[sender.tag].o03 = 1
                Shared.shared.rodzaje[sender.tag].o04 = 0
                Shared.shared.rodzaje[sender.tag].o05 = 0
                Shared.shared.rodzaje[sender.tag].o06 = 0
                Shared.shared.rodzaje[sender.tag].o07 = 0
                Shared.shared.rodzaje[sender.tag].o08 = 0
                Shared.shared.rodzaje[sender.tag].o09 = 0
                Shared.shared.rodzaje[sender.tag].o10 = 0
                Shared.shared.rodzaje[sender.tag].do_oceny = 0
                
                if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                    //update ocenionej kategorii na serwerze cobytu.com
                    let res = self.aktualizujSkladnik(ud_lubi: "3", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 1, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }else{ //dla kategorii startowych
                    //update ocenionej kategorii startowej na serwerze cobytu.com
                    let res = self.aktualizujStartowe(us_lubi: "3", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 1, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }
                
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.rodzaje[sender.tag].o01 = 0
            Shared.shared.rodzaje[sender.tag].o02 = 0
            Shared.shared.rodzaje[sender.tag].o03 = 1
            Shared.shared.rodzaje[sender.tag].o04 = 0
            Shared.shared.rodzaje[sender.tag].o05 = 0
            Shared.shared.rodzaje[sender.tag].o06 = 0
            Shared.shared.rodzaje[sender.tag].o07 = 0
            Shared.shared.rodzaje[sender.tag].o08 = 0
            Shared.shared.rodzaje[sender.tag].o09 = 0
            Shared.shared.rodzaje[sender.tag].o10 = 0
            Shared.shared.rodzaje[sender.tag].do_oceny = 0
            
            if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "3", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 1, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }else{ //dla kategorii startowych
                //update ocenionej kategorii startowej na serwerze cobytu.com
                let res = self.aktualizujStartowe(us_lubi: "3", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 1, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }
        }
    }
    
    @IBAction func buzia04(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_KATEGORIE".localized() + " '\(Shared.shared.rodzaje[sender.tag].rd_rodzaj)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.rodzaje[sender.tag].total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_NIECHETNIE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.rodzaje[sender.tag].o01 = 0
                Shared.shared.rodzaje[sender.tag].o02 = 0
                Shared.shared.rodzaje[sender.tag].o03 = 0
                Shared.shared.rodzaje[sender.tag].o04 = 1
                Shared.shared.rodzaje[sender.tag].o05 = 0
                Shared.shared.rodzaje[sender.tag].o06 = 0
                Shared.shared.rodzaje[sender.tag].o07 = 0
                Shared.shared.rodzaje[sender.tag].o08 = 0
                Shared.shared.rodzaje[sender.tag].o09 = 0
                Shared.shared.rodzaje[sender.tag].o10 = 0
                Shared.shared.rodzaje[sender.tag].do_oceny = 0
                
                if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                    //update ocenionej kategorii na serwerze cobytu.com
                    let res = self.aktualizujSkladnik(ud_lubi: "4", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 1, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }else{ //dla kategorii startowych
                    //update ocenionej kategorii startowej na serwerze cobytu.com
                    let res = self.aktualizujStartowe(us_lubi: "4", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 1, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }
                
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.rodzaje[sender.tag].o01 = 0
            Shared.shared.rodzaje[sender.tag].o02 = 0
            Shared.shared.rodzaje[sender.tag].o03 = 0
            Shared.shared.rodzaje[sender.tag].o04 = 1
            Shared.shared.rodzaje[sender.tag].o05 = 0
            Shared.shared.rodzaje[sender.tag].o06 = 0
            Shared.shared.rodzaje[sender.tag].o07 = 0
            Shared.shared.rodzaje[sender.tag].o08 = 0
            Shared.shared.rodzaje[sender.tag].o09 = 0
            Shared.shared.rodzaje[sender.tag].o10 = 0
            Shared.shared.rodzaje[sender.tag].do_oceny = 0
            
            if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "4", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 1, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }else{ //dla kategorii startowych
                //update ocenionej kategorii startowej na serwerze cobytu.com
                let res = self.aktualizujStartowe(us_lubi: "4", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 1, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }
        }
    }
    @IBAction func buzia05(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_KATEGORIE".localized() + " '\(Shared.shared.rodzaje[sender.tag].rd_rodzaj)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.rodzaje[sender.tag].total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_BEZ_EMOCJI".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.rodzaje[sender.tag].o01 = 0
                Shared.shared.rodzaje[sender.tag].o02 = 0
                Shared.shared.rodzaje[sender.tag].o03 = 0
                Shared.shared.rodzaje[sender.tag].o04 = 0
                Shared.shared.rodzaje[sender.tag].o05 = 1
                Shared.shared.rodzaje[sender.tag].o06 = 0
                Shared.shared.rodzaje[sender.tag].o07 = 0
                Shared.shared.rodzaje[sender.tag].o08 = 0
                Shared.shared.rodzaje[sender.tag].o09 = 0
                Shared.shared.rodzaje[sender.tag].o10 = 0
                Shared.shared.rodzaje[sender.tag].do_oceny = 0
                
                if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                    //update ocenionej kategorii na serwerze cobytu.com
                    let res = self.aktualizujSkladnik(ud_lubi: "5", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 1, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }else{ //dla kategorii startowych
                    //update ocenionej kategorii startowej na serwerze cobytu.com
                    let res = self.aktualizujStartowe(us_lubi: "5", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 1, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }
                
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.rodzaje[sender.tag].o01 = 0
            Shared.shared.rodzaje[sender.tag].o02 = 0
            Shared.shared.rodzaje[sender.tag].o03 = 0
            Shared.shared.rodzaje[sender.tag].o04 = 0
            Shared.shared.rodzaje[sender.tag].o05 = 1
            Shared.shared.rodzaje[sender.tag].o06 = 0
            Shared.shared.rodzaje[sender.tag].o07 = 0
            Shared.shared.rodzaje[sender.tag].o08 = 0
            Shared.shared.rodzaje[sender.tag].o09 = 0
            Shared.shared.rodzaje[sender.tag].o10 = 0
            Shared.shared.rodzaje[sender.tag].do_oceny = 0
            
            if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "5", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 1, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }else{ //dla kategorii startowych
                //update ocenionej kategorii startowej na serwerze cobytu.com
                let res = self.aktualizujStartowe(us_lubi: "5", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 1, b06: 0, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }
        }
    }
    @IBAction func buzia06(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_KATEGORIE".localized() + " '\(Shared.shared.rodzaje[sender.tag].rd_rodzaj)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.rodzaje[sender.tag].total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_MOGE_SPROBOWAC".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.rodzaje[sender.tag].o01 = 0
                Shared.shared.rodzaje[sender.tag].o02 = 0
                Shared.shared.rodzaje[sender.tag].o03 = 0
                Shared.shared.rodzaje[sender.tag].o04 = 0
                Shared.shared.rodzaje[sender.tag].o05 = 0
                Shared.shared.rodzaje[sender.tag].o06 = 1
                Shared.shared.rodzaje[sender.tag].o07 = 0
                Shared.shared.rodzaje[sender.tag].o08 = 0
                Shared.shared.rodzaje[sender.tag].o09 = 0
                Shared.shared.rodzaje[sender.tag].o10 = 0
                Shared.shared.rodzaje[sender.tag].do_oceny = 0
                
                if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                    //update ocenionej kategorii na serwerze cobytu.com
                    let res = self.aktualizujSkladnik(ud_lubi: "6", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 1, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }else{ //dla kategorii startowych
                    //update ocenionej kategorii startowej na serwerze cobytu.com
                    let res = self.aktualizujStartowe(us_lubi: "6", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 1, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }
                
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.rodzaje[sender.tag].o01 = 0
            Shared.shared.rodzaje[sender.tag].o02 = 0
            Shared.shared.rodzaje[sender.tag].o03 = 0
            Shared.shared.rodzaje[sender.tag].o04 = 0
            Shared.shared.rodzaje[sender.tag].o05 = 0
            Shared.shared.rodzaje[sender.tag].o06 = 1
            Shared.shared.rodzaje[sender.tag].o07 = 0
            Shared.shared.rodzaje[sender.tag].o08 = 0
            Shared.shared.rodzaje[sender.tag].o09 = 0
            Shared.shared.rodzaje[sender.tag].o10 = 0
            Shared.shared.rodzaje[sender.tag].do_oceny = 0
            
            if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "6", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 1, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }else{ //dla kategorii startowych
                //update ocenionej kategorii startowej na serwerze cobytu.com
                let res = self.aktualizujStartowe(us_lubi: "6", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 1, b07: 0, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }
        }
    }
    @IBAction func buzia07(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_KATEGORIE".localized() + " '\(Shared.shared.rodzaje[sender.tag].rd_rodzaj)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.rodzaje[sender.tag].total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_CHETNIE_SPROBUJE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.rodzaje[sender.tag].o01 = 0
                Shared.shared.rodzaje[sender.tag].o02 = 0
                Shared.shared.rodzaje[sender.tag].o03 = 0
                Shared.shared.rodzaje[sender.tag].o04 = 0
                Shared.shared.rodzaje[sender.tag].o05 = 0
                Shared.shared.rodzaje[sender.tag].o06 = 0
                Shared.shared.rodzaje[sender.tag].o07 = 1
                Shared.shared.rodzaje[sender.tag].o08 = 0
                Shared.shared.rodzaje[sender.tag].o09 = 0
                Shared.shared.rodzaje[sender.tag].o10 = 0
                Shared.shared.rodzaje[sender.tag].do_oceny = 0
                
                if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                    //update ocenionej kategorii na serwerze cobytu.com
                    let res = self.aktualizujSkladnik(ud_lubi: "7", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 1, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }else{ //dla kategorii startowych
                    //update ocenionej kategorii startowej na serwerze cobytu.com
                    let res = self.aktualizujStartowe(us_lubi: "7", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 1, b08: 0, b09: 0, b10: 0, rdocena: 1)
                    }
                }
                
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.rodzaje[sender.tag].o01 = 0
            Shared.shared.rodzaje[sender.tag].o02 = 0
            Shared.shared.rodzaje[sender.tag].o03 = 0
            Shared.shared.rodzaje[sender.tag].o04 = 0
            Shared.shared.rodzaje[sender.tag].o05 = 0
            Shared.shared.rodzaje[sender.tag].o06 = 0
            Shared.shared.rodzaje[sender.tag].o07 = 1
            Shared.shared.rodzaje[sender.tag].o08 = 0
            Shared.shared.rodzaje[sender.tag].o09 = 0
            Shared.shared.rodzaje[sender.tag].o10 = 0
            Shared.shared.rodzaje[sender.tag].do_oceny = 0
            
            if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "7", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 1, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }else{ //dla kategorii startowych
                //update ocenionej kategorii startowej na serwerze cobytu.com
                let res = self.aktualizujStartowe(us_lubi: "7", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 1, b08: 0, b09: 0, b10: 0, rdocena: 1)
                }
            }
        }
    }
    @IBAction func buzia08(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_KATEGORIE".localized() + " '\(Shared.shared.rodzaje[sender.tag].rd_rodzaj)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.rodzaje[sender.tag].total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_LUBIE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                //print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.rodzaje[sender.tag].o01 = 0
                Shared.shared.rodzaje[sender.tag].o02 = 0
                Shared.shared.rodzaje[sender.tag].o03 = 0
                Shared.shared.rodzaje[sender.tag].o04 = 0
                Shared.shared.rodzaje[sender.tag].o05 = 0
                Shared.shared.rodzaje[sender.tag].o06 = 0
                Shared.shared.rodzaje[sender.tag].o07 = 0
                Shared.shared.rodzaje[sender.tag].o08 = 1
                Shared.shared.rodzaje[sender.tag].o09 = 0
                Shared.shared.rodzaje[sender.tag].o10 = 0
                Shared.shared.rodzaje[sender.tag].do_oceny = 0
                
                if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                    //update ocenionej kategorii na serwerze cobytu.com
                    let res = self.aktualizujSkladnik(ud_lubi: "8", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 1, b09: 0, b10: 0, rdocena: 1)
                    }
                }else{ //dla kategorii startowych
                    //update ocenionej kategorii startowej na serwerze cobytu.com
                    let res = self.aktualizujStartowe(us_lubi: "8", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 1, b09: 0, b10: 0, rdocena: 1)
                    }
                }
                
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.rodzaje[sender.tag].o01 = 0
            Shared.shared.rodzaje[sender.tag].o02 = 0
            Shared.shared.rodzaje[sender.tag].o03 = 0
            Shared.shared.rodzaje[sender.tag].o04 = 0
            Shared.shared.rodzaje[sender.tag].o05 = 0
            Shared.shared.rodzaje[sender.tag].o06 = 0
            Shared.shared.rodzaje[sender.tag].o07 = 0
            Shared.shared.rodzaje[sender.tag].o08 = 1
            Shared.shared.rodzaje[sender.tag].o09 = 0
            Shared.shared.rodzaje[sender.tag].o10 = 0
            Shared.shared.rodzaje[sender.tag].do_oceny = 0
            
            if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "8", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 1, b09: 0, b10: 0, rdocena: 1)
                }
            }else{ //dla kategorii startowych
                //update ocenionej kategorii startowej na serwerze cobytu.com
                let res = self.aktualizujStartowe(us_lubi: "8", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 1, b09: 0, b10: 0, rdocena: 1)
                }
            }
        }
    }
    @IBAction func buzia09(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_KATEGORIE".localized() + " '\(Shared.shared.rodzaje[sender.tag].rd_rodzaj)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.rodzaje[sender.tag].total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_BARDZO_LUBIE".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.rodzaje[sender.tag].o01 = 0
                Shared.shared.rodzaje[sender.tag].o02 = 0
                Shared.shared.rodzaje[sender.tag].o03 = 0
                Shared.shared.rodzaje[sender.tag].o04 = 0
                Shared.shared.rodzaje[sender.tag].o05 = 0
                Shared.shared.rodzaje[sender.tag].o06 = 0
                Shared.shared.rodzaje[sender.tag].o07 = 0
                Shared.shared.rodzaje[sender.tag].o08 = 0
                Shared.shared.rodzaje[sender.tag].o09 = 1
                Shared.shared.rodzaje[sender.tag].o10 = 0
                Shared.shared.rodzaje[sender.tag].do_oceny = 0
                
                if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                    //update ocenionej kategorii na serwerze cobytu.com
                    let res = self.aktualizujSkladnik(ud_lubi: "9", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 1, b10: 0, rdocena: 1)
                    }
                }else{ //dla kategorii startowych
                    //update ocenionej kategorii startowej na serwerze cobytu.com
                    let res = self.aktualizujStartowe(us_lubi: "9", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 1, b10: 0, rdocena: 1)
                    }
                }
                
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.rodzaje[sender.tag].o01 = 0
            Shared.shared.rodzaje[sender.tag].o02 = 0
            Shared.shared.rodzaje[sender.tag].o03 = 0
            Shared.shared.rodzaje[sender.tag].o04 = 0
            Shared.shared.rodzaje[sender.tag].o05 = 0
            Shared.shared.rodzaje[sender.tag].o06 = 0
            Shared.shared.rodzaje[sender.tag].o07 = 0
            Shared.shared.rodzaje[sender.tag].o08 = 0
            Shared.shared.rodzaje[sender.tag].o09 = 1
            Shared.shared.rodzaje[sender.tag].o10 = 0
            Shared.shared.rodzaje[sender.tag].do_oceny = 0
            
            if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "9", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 1, b10: 0, rdocena: 1)
                }
            }else{ //dla kategorii startowych
                //update ocenionej kategorii startowej na serwerze cobytu.com
                let res = self.aktualizujStartowe(us_lubi: "9", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 1, b10: 0, rdocena: 1)
                }
            }
        }
    }
    @IBAction func buzia10(_ sender: UIButton) {
        if Shared.shared.ostrzezenia == "1" {
            let alertController = UIAlertController(title: "L_OSTRZEZENIE".localized(), message: "L_WSZYSTKIE_KATEGORIE".localized() + " '\(Shared.shared.rodzaje[sender.tag].rd_rodzaj)' (" +  "L_KTORYCH_JEST".localized() + " \(Shared.shared.rodzaje[sender.tag].total)) " + "L_OTRZYMAJA".localized() + " = '" + "L_UWIELBIAM".localized() + "'", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "L_ANULUJ".localized(), style: .default){
                (action:UIAlertAction!) in
                print ("Anuluj")
            }
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //update w pamięci podręcznej
                Shared.shared.rodzaje[sender.tag].o01 = 0
                Shared.shared.rodzaje[sender.tag].o02 = 0
                Shared.shared.rodzaje[sender.tag].o03 = 0
                Shared.shared.rodzaje[sender.tag].o04 = 0
                Shared.shared.rodzaje[sender.tag].o05 = 0
                Shared.shared.rodzaje[sender.tag].o06 = 0
                Shared.shared.rodzaje[sender.tag].o07 = 0
                Shared.shared.rodzaje[sender.tag].o08 = 0
                Shared.shared.rodzaje[sender.tag].o09 = 0
                Shared.shared.rodzaje[sender.tag].o10 = 1
                Shared.shared.rodzaje[sender.tag].do_oceny = 0
                
                if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                    //update ocenionej kategorii na serwerze cobytu.com
                    let res = self.aktualizujSkladnik(ud_lubi: "10", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 1, rdocena: 1)
                    }
                }else{ //dla kategorii startowych
                    //update ocenionej kategorii startowej na serwerze cobytu.com
                    let res = self.aktualizujStartowe(us_lubi: "10", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                    if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                        //odświeżenie celi z ocenioną kategorią
                        self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                        //update ocenionej kategorii w bazie lokalnej
                        _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 1, rdocena: 1)
                    }
                }
                
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //update w pamięci podręcznej
            Shared.shared.rodzaje[sender.tag].o01 = 0
            Shared.shared.rodzaje[sender.tag].o02 = 0
            Shared.shared.rodzaje[sender.tag].o03 = 0
            Shared.shared.rodzaje[sender.tag].o04 = 0
            Shared.shared.rodzaje[sender.tag].o05 = 0
            Shared.shared.rodzaje[sender.tag].o06 = 0
            Shared.shared.rodzaje[sender.tag].o07 = 0
            Shared.shared.rodzaje[sender.tag].o08 = 0
            Shared.shared.rodzaje[sender.tag].o09 = 0
            Shared.shared.rodzaje[sender.tag].o10 = 1
            Shared.shared.rodzaje[sender.tag].do_oceny = 0
            
            if Shared.shared.rodzaje.count != 6 { //dla kategorii właściwych
                //update ocenionej kategorii na serwerze cobytu.com
                let res = self.aktualizujSkladnik(ud_lubi: "10", rd_id: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 1, rdocena: 1)
                }
            }else{ //dla kategorii startowych
                //update ocenionej kategorii startowej na serwerze cobytu.com
                let res = self.aktualizujStartowe(us_lubi: "10", us_ss_sg: String(Shared.shared.rodzaje[sender.tag].rd_id))
                if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
                    //odświeżenie celi z ocenioną kategorią
                    self.tableWiewRodzaje.reloadRows(at: [[0, sender.tag]], with: .none)
                    //update ocenionej kategorii w bazie lokalnej
                    _ = StephencelisDB.instance.updateRodzaje(rdid: Shared.shared.rodzaje[sender.tag].rd_id, dooceny: 0, b01: 0, b02: 0, b03: 0, b04: 0, b05: 0, b06: 0, b07: 0, b08: 0, b09: 0, b10: 1, rdocena: 1)
                }
            }
        }
    }
    
    
    
    
    //----------------------------------------------------------
    //aktualizacja ocenianej kategorii składników na serwerze
    //----------------------------------------------------------
    func aktualizujSkladnik(ud_lubi: String, rd_id: String)  -> Int  {
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
                          "nd_id": "0",] as [String: String]
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
    //funkcja pobierająca JSONa z nazwami składników
    //=========================================================
    func downloadJSON_nazwy(completed: @escaping () -> ()) {
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_nazwy_do&uz_id=\(Shared.shared.uz_id!)&rd=\(Shared.shared.rd_id!)&lang=\(Localize.currentLanguage())")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            //print("url nazwy")
            //print(url)
            if error == nil{
                do {
                   // print(data)
                    self.nazwaSkladnika = try JSONDecoder().decode([NazwaSk].self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print ("JSON Error nazwy")
                }
            }
        }.resume()
    }
    
    //----------------------------------------------------------
    //aktualizacja ocenianej kategorii składników startowych na serwerze
    //----------------------------------------------------------
    func aktualizujStartowe(us_lubi: String, us_ss_sg: String)  -> Int  {
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_lubi_start.php")
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["us_ss_id": "0",
                          "us_lubi": us_lubi,
                          "us_uz_id": Shared.shared.uz_id,
                          "us_ss_sg": us_ss_sg,] as [String: String]
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
    //funkcja pobierająca JSONa z nazwami startowymi składników (do tabeli form)
    //=========================================================
    func downloadJSON_formy_nazwyStartowe(completed: @escaping () -> ()) {
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_formy_do&uz_id=\(Shared.shared.uz_id!)&rd=\(Shared.shared.rd_id!)&nd=0&lang=\(Localize.currentLanguage())")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            //print("do startowych = ")
            if error == nil{
                do {
                     //print(data)
                    self.formaSkladnika = try JSONDecoder().decode([FormaSk].self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print ("JSON Error formy startowe")
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
