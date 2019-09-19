//
//  ChildViewController51.swift
//  Pager
//
//  Created by darys on 01.04.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import RestEssentials
import Localize_Swift

class CastomCell51: UITableViewCell{
    
    @IBOutlet weak var nazwa5: UILabel!
    @IBOutlet weak var opis5: UILabel!
    @IBOutlet weak var cena5: UILabel!
    @IBOutlet weak var uwaga5: UIImageView!
    @IBOutlet weak var ulubione5: UIButton!
    
    
}

class CastomCell51a: UITableViewCell{
    
    @IBOutlet weak var nazwa5: UILabel!
    @IBOutlet weak var opis5: UILabel!
    @IBOutlet weak var cena5: UILabel!
    @IBOutlet weak var foto5: UIImageView!
    @IBOutlet weak var uwaga5: UIImageView!
    @IBOutlet weak var ulubione5: UIButton!
    
    
}


class ChildViewController51: UIViewController, IndicatorInfoProvider{
    
    @IBOutlet weak var tableView5: UITableView!
   
    
    var listaDan5 = [Mealdb]()  //DB lista dań
    var nh: Network? //do pobierania zdjęć z sieci
    var meal = [MealState]()
    var reachability: Reachability?  //dostępność Internetu
    
    
    //==============================
    //odświeżenie widoku listy dań
    //==============================
    lazy var refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(ChildViewController51.aktualizacjaDanych(_:)), for: .valueChanged)
        //refControl.tintColor = UIColor.red
        return refControl
    }()
    
    @objc func aktualizacjaDanych(_ refControl: UIRefreshControl){
        listaDan5 = StephencelisDB.instance.getDania(kat: "4") //pobranie dań z bazy lokalnej (a trzeba z sieci)
        self.tableView5.reloadData()
        refControl.endRefreshing()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
  //      AppDelegate.which_page = 4 //zapamiętanie numeru strony - żeby wrócić np. po zmianie języka
        
        listaDan5 = StephencelisDB.instance.getDaniaPodkat(kat: "4",pod: "%\(Shared.shared.podkategoria!)%") //pobranie dań z bazy
        Shared.shared.podkategoria = "" //kasowanie ustawień filtrowania po podkategorii
        //print(listaDan5)
        self.tableView5.addSubview(self.refreshControl)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo (title: "L_DANIA_GLOWNE".localized()) //NSLocalizedString("L_SNIADANIA", comment: " ŚNIADANIA")
    }
    
}

//====================================
//wyświetlenie dań w widoku tabeli z daniami
//====================================
extension ChildViewController51: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaDan5.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let circleLabel: UILabel = {
            let label = UILabel()
            //label.text = "100"
            label.textColor = Shared.shared.malinaColor
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 12)
            return label
        }()
        
        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
        
        if listaDan5[indexPath.row].foto != "co.jpg"{  //jeżeli jest zdjęcie dania
            //pobranie komórki z tabeli
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastomCell51a", for: indexPath) as? CastomCell51a else {
                fatalError("Komórka nie jest instancją CastomCell51")
            }

            //żeby nie znikało tło pod napisami po wybraniu celi
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.nazwa5.text = listaDan5[indexPath.row].nazwa
            cell.opis5.text = listaDan5[indexPath.row].opis
            //cell.cena5.text = listaDan5[indexPath.row].cena
            //formatowanie i wyświetlanie ceny dostawy
            if listaDan5[indexPath.row].cena != "wr"{
                let numCena = formatter1.string(from: NSNumber(value: Float(listaDan5[indexPath.row].cena)!))
                if Shared.shared.uz_id! == "" {
                    cell.cena5.text = "\(numCena! ) " + "L_PLN".localized()//cena menu + opakowania
                }else{
                    cell.cena5.text = numCena!
                }
            }else{
                cell.cena5.text = listaDan5[indexPath.row].cena
            }
            
            if listaDan5[indexPath.row].lubi != "0"{
                let lubienie = Float(listaDan5[indexPath.row].lubi)
                //wskaźnik lubienia
                let trackLayer = CAShapeLayer()
                let circulerPath = UIBezierPath(arcCenter: CGPoint(x:100, y:88),  radius: 13, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
                trackLayer.path = circulerPath.cgPath
                trackLayer.strokeColor = UIColor.lightGray.cgColor
                trackLayer.lineWidth = 3
                trackLayer.fillColor = UIColor.white.cgColor
                cell.layer.addSublayer(trackLayer)
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = circulerPath.cgPath
                shapeLayer.strokeColor = UIColor.red.cgColor
                shapeLayer.lineWidth = 3
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.strokeEnd = CGFloat(((lubienie!) - (lubienie! * 0.2)) / 100) //żeby zaczynało się od góry
                cell.layer.addSublayer(shapeLayer)
                //tekst w kółku
                circleLabel.text = listaDan5[indexPath.row].lubi
                cell.addSubview(circleLabel)
                circleLabel.frame = CGRect(x: 85, y: 73, width: 30, height: 30)
            }else{
                if Shared.shared.uz_id! != "" {
                    //wskaźnik lubienia
                    let trackLayer = CAShapeLayer()
                    let circulerPath = UIBezierPath(arcCenter: CGPoint(x:100, y:88),  radius: 13, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
                    trackLayer.path = circulerPath.cgPath
                    trackLayer.strokeColor = UIColor.lightGray.cgColor
                    trackLayer.lineWidth = 3
                    trackLayer.fillColor = UIColor.white.cgColor
                    cell.layer.addSublayer(trackLayer)
                    //tekst w kółku
                    circleLabel.text = listaDan5[indexPath.row].lubi
                    cell.addSubview(circleLabel)
                    circleLabel.frame = CGRect(x: 85, y: 73, width: 30, height: 30)
                }
            }
            
            if listaDan5[indexPath.row].foto == "co.jpg" {
                cell.foto5.image = UIImage(named: "brak2.jpg")
            }else{
                //pobranie zdjęcia dania
                nh = Network()
                nh?.getPictureFromServer(imageName: listaDan5[indexPath.row].foto, callback: { (image:UIImage)->Void in
                    DispatchQueue.main.async{
                        cell.foto5.image = image
                    }
                })
            }
            
            if Shared.shared.uz_id! != "" {
                //ikona uwaga - alergeny
                if listaDan5[indexPath.row].alergeny != "brak" {
                    cell.uwaga5.image = UIImage(named: "uwaga.jpg")
                }else{
                    cell.uwaga5.image = nil
                }
                
                //ikona ulubione
                if listaDan5[indexPath.row].fav == "1" {
                    cell.ulubione5.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
                    cell.ulubione5.tag = indexPath.row
                    cell.ulubione5.addTarget(self, action: #selector(self.usun_ulubione), for: .touchUpInside)
                }else{
                    cell.ulubione5.setImage(#imageLiteral(resourceName: "heartb"), for: .normal)
                    cell.ulubione5.tag = indexPath.row
                    cell.ulubione5.addTarget(self, action: #selector(self.dodaj_ulubione), for: .touchUpInside)
                }
            }
            
            return cell
        }else { //jeżeli brak zdjęcia dania
    
            //pobranie komórki z tabeli
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastomCell51", for: indexPath) as? CastomCell51 else {
                fatalError("Komórka nie jest instancją CastomCell51")
            }
            
            //żeby nie znikało tło pod napisami po wybraniu celi
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.nazwa5.text = listaDan5[indexPath.row].nazwa
            cell.opis5.text = listaDan5[indexPath.row].opis
            cell.cena5.text = listaDan5[indexPath.row].cena
            //formatowanie i wyświetlanie ceny dostawy
            let numCena = formatter1.string(from: NSNumber(value: Float(listaDan5[indexPath.row].cena)!))
            if Shared.shared.uz_id! == "" {
                cell.cena5.text = "\(numCena! ) " + "L_PLN".localized()//cena menu + opakowania
            }else{
                cell.cena5.text = numCena!
            }
            
            if listaDan5[indexPath.row].lubi != "0"{
                let lubienie = Float(listaDan5[indexPath.row].lubi)
                //wskaźnik lubienia
                let trackLayer = CAShapeLayer()
                let circulerPath = UIBezierPath(arcCenter: CGPoint(x:100, y:88),  radius: 13, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
                trackLayer.path = circulerPath.cgPath
                trackLayer.strokeColor = UIColor.lightGray.cgColor
                trackLayer.lineWidth = 3
                trackLayer.fillColor = UIColor.white.cgColor
                cell.layer.addSublayer(trackLayer)
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = circulerPath.cgPath
                shapeLayer.strokeColor = UIColor.red.cgColor
                shapeLayer.lineWidth = 3
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.strokeEnd = CGFloat(((lubienie!) - (lubienie! * 0.2)) / 100) //żeby zaczynało się od góry
                cell.layer.addSublayer(shapeLayer)
                //tekst w kółku
                circleLabel.text = listaDan5[indexPath.row].lubi
                cell.addSubview(circleLabel)
                circleLabel.frame = CGRect(x: 85, y: 73, width: 30, height: 30)
            }else{
                if Shared.shared.uz_id! != "" {
                    //wskaźnik lubienia
                    let trackLayer = CAShapeLayer()
                    let circulerPath = UIBezierPath(arcCenter: CGPoint(x:100, y:88),  radius: 13, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
                    trackLayer.path = circulerPath.cgPath
                    trackLayer.strokeColor = UIColor.lightGray.cgColor
                    trackLayer.lineWidth = 3
                    trackLayer.fillColor = UIColor.white.cgColor
                    cell.layer.addSublayer(trackLayer)
                    //tekst w kółku
                    circleLabel.text = listaDan5[indexPath.row].lubi
                    cell.addSubview(circleLabel)
                    circleLabel.frame = CGRect(x: 85, y: 73, width: 30, height: 30)
                }
            }
            
            if Shared.shared.uz_id! != "" {
                //ikona uwaga - alergeny
                if listaDan5[indexPath.row].alergeny != "brak" {
                    cell.uwaga5.image = UIImage(named: "uwaga.jpg")
                }else{
                    cell.uwaga5.image = nil
                }
                
                //ikona ulubione
                if listaDan5[indexPath.row].fav == "1" {
                    cell.ulubione5.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
                    cell.ulubione5.tag = indexPath.row
                    cell.ulubione5.addTarget(self, action: #selector(self.usun_ulubione), for: .touchUpInside)
                }else{
                    cell.ulubione5.setImage(#imageLiteral(resourceName: "heartb"), for: .normal)
                    cell.ulubione5.tag = indexPath.row
                    cell.ulubione5.addTarget(self, action: #selector(self.dodaj_ulubione), for: .touchUpInside)
                }
            }
            
            return cell
        }
        //return UITableViewCell()
    }
    
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 110
    }
    
    //===============================
    //napis "Brak dań"
    //===============================
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if listaDan5.isEmpty{
            return 70
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "L_BRAK_DAN".localized() + "..."
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    
    //================================
    //dodaj danie do ulubionych
    //================================
    @IBAction func dodaj_ulubione(_ sender: UIButton) {
        listaDan5[sender.tag].fav = "1"  //polubienie dania
        //update lubienia na serwerze cobytu.com
        let res = self.zmien_polubienie(da_id: String(listaDan5[sender.tag].daid), fav: "1")
       
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z polubionym daniem
            self.tableView5.reloadRows(at: [[0, sender.tag]], with: .none)
            //update polubienia dania w bazie lokalnej
            _ = StephencelisDB.instance.updateFavDania(daid: listaDan5[sender.tag].daid, fav: "1")
        }
    }
    
    //================================
    //usuń danie z ulubionych
    //================================
    @IBAction func usun_ulubione(_ sender: UIButton) {
        listaDan5[sender.tag].fav = "0"  //nie polubienie dania
        //update lubienia na serwerze cobytu.com
        let res = self.zmien_polubienie(da_id: String(listaDan5[sender.tag].daid), fav: "0")
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z polubionym daniem
            self.tableView5.reloadRows(at: [[0, sender.tag]], with: .none)
            //update polubienia dania w bazie lokalnej
            _ = StephencelisDB.instance.updateFavDania(daid: listaDan5[sender.tag].daid, fav: "0")
        }
    }
    
    //----------------------------------------------------------
    //aktualizacja polubienia dania na serwerze
    //----------------------------------------------------------
    func zmien_polubienie(da_id: String, fav: String)  -> Int  {
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_favorite.php")
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["uz_id": Shared.shared.uz_id,
                          "da_id": da_id,
                          "fav": fav] as [String: String]
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
                //print ("json:====== \(String(describing: json!))")
                //print ("json:==\(String(describing: json!["error_email"]!))")
                
                let success = String(describing: json!["success"])
                //print("success=\(success)")
                
                if (success != "Optional(1)"){
                    return
                }else{
                    //powiodło sie)
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
    
    
    
    
    //========================
    //Zapamiętanie id wybranego (klikniętego) dania - dla widoku szczegółów
    //========================
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIdDania = listaDan5[indexPath.row].daid
        
        //update id wybranego dania w bazie lokalnej - nowe id zapisane do tabeli 'memory'
        _ = StephencelisDB.instance.updateMemory(mem: "mem_danie", a: selectedIdDania, b: listaDan5[indexPath.row].foto, c: listaDan5[indexPath.row].alergeny, d: listaDan5[indexPath.row].nazwa, e: "", f: "")
        Shared.shared.wyborIdWersja = 0 //index pierwszego miejsca na liście wersji = 0
        //sprawdzenie dostępu do Internetu
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            performSegue(withIdentifier: "showDetails51", sender: self) //przejście do TabBarController
        }else{ //jeżeli nie ma Internetu
            displayAlert()
        }
    }
    
    //komunikat "Brak Internetu"
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }
}

