//
//  ChildViewController6.swift
//  Pager
//
//  Created by darys on 05.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RestEssentials

class ChildViewController6: UIViewController, IndicatorInfoProvider{
    
    @IBOutlet weak var tableView6: UITableView!
    
    
    var listaDan6 = [Mealdb]()  //DB lista dań
    var nh: Network? //do pobierania zdjęć z sieci
    var meal = [MealState]()
    var reachability: Reachability?  //dostępność Internetu
    
    //==============================
    //odświeżenie widoku listy dań
    //==============================
    lazy var refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(ChildViewController6.aktualizacjaDanych(_:)), for: .valueChanged)
        //refControl.tintColor = UIColor.red
        return refControl
    }()
    
    @objc func aktualizacjaDanych(_ refControl: UIRefreshControl){
        listaDan6 = StephencelisDB.instance.getDania(kat: "5") //pobranie dań z bazy lokalnej (a trzeba z sieci)
        self.tableView6.reloadData()
        refControl.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listaDan6 = StephencelisDB.instance.getDaniaPodkat(kat: "5",pod: "%\(Shared.shared.podkategoria!)%") //pobranie dań z bazy
        Shared.shared.podkategoria = "" //kasowanie ustawień filtrowania po podkategorii
        
        self.tableView6.addSubview(self.refreshControl)
       // AppDelegate.which_page = 5 //zapamiętanie numeru strony - żeby wrócić np. po zmianie języka
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "L_DLA_DZIECI".localized())
    }
    
}

//====================================
//wyświetlenie dań w widoku tabeli z daniami
//====================================
extension ChildViewController6: UITableViewDataSource, UITableViewDelegate {
    
    //ilość sekcji w tabeli
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //ilość wierszy w tabeli
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaDan6.count
    }
    
    //konfigurowanie celi (wiersza tabeli)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //pobranie komórki z tabeli
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Meal6TableViewCell", for: indexPath) as? Meal6TableViewCell else {
            fatalError("Komórka nie jest instancją Meal6TableViewCell")
        }
        
        let circleLabel: UILabel = {
            let label = UILabel()
            label.textColor = Shared.shared.malinaColor
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 24)
            return label
        }()
        
        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
        
        //żeby nie znikało tło pod napisami po wybraniu celi
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.starsView6.settings.updateOnTouch = false
        cell.starsView6.rating = Double(listaDan6[indexPath.row].srednia)!
        cell.starsView6.text = listaDan6[indexPath.row].srednia
        //załadowanie danych dań
        cell.nameLabel6.text = listaDan6[indexPath.row].nazwa
        //cell.cenaLabel6.text = listaDan6[indexPath.row].cena
        //formatowanie i wyświetlanie ceny
        if listaDan6[indexPath.row].cena != "wr"{
            let numCena = formatter1.string(from: NSNumber(value: Float(listaDan6[indexPath.row].cena)!))
            cell.cenaLabel6.text = "\(numCena! ) " + "L_PLN".localized()//cena menu + opakowania
        }else{
            cell.cenaLabel6.text = listaDan6[indexPath.row].cena
        }
        cell.czasLabel6.text = "\(listaDan6[indexPath.row].czas) " + "L_MIN".localized()
        cell.wagaLabel6.text = "\(listaDan6[indexPath.row].waga) " + "L_G".localized()
        cell.kcalLabel6.text = "\(listaDan6[indexPath.row].kcal) " + "L_KCAL".localized()
        
        if listaDan6[indexPath.row].lubi != "0"{
            let lubienie = Float(listaDan6[indexPath.row].lubi)
            //wskaźnik lubienia
            let trackLayer = CAShapeLayer()
            let circulerPath = UIBezierPath(arcCenter: CGPoint(x:47, y:100),  radius: 30, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
            trackLayer.path = circulerPath.cgPath
            trackLayer.strokeColor = UIColor.lightGray.cgColor
            trackLayer.lineWidth = 10
            trackLayer.fillColor = UIColor.white.cgColor
            cell.layer.addSublayer(trackLayer)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circulerPath.cgPath
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = 10
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeEnd = CGFloat(((lubienie!) - (lubienie! * 0.2)) / 100) //żeby zaczynało się od góry
            cell.layer.addSublayer(shapeLayer)
            //tekst w kółku
            circleLabel.text = listaDan6[indexPath.row].lubi
            cell.addSubview(circleLabel)
            circleLabel.frame = CGRect(x: 25, y: 78, width: 45, height: 45)
        }else{
            if Shared.shared.uz_id! != "" {
                //wskaźnik lubienia
                let trackLayer = CAShapeLayer()
                let circulerPath = UIBezierPath(arcCenter: CGPoint(x:47, y:100),  radius: 30, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
                trackLayer.path = circulerPath.cgPath
                trackLayer.strokeColor = UIColor.lightGray.cgColor
                trackLayer.lineWidth = 10
                trackLayer.fillColor = UIColor.white.cgColor
                cell.layer.addSublayer(trackLayer)
                //tekst w kółku
                circleLabel.text = listaDan6[indexPath.row].lubi
                cell.addSubview(circleLabel)
                circleLabel.frame = CGRect(x: 25, y: 78, width: 45, height: 45)
            }
        }
        
        //sprawdzenie dostępu do Internetu
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            if listaDan6[indexPath.row].foto == "co.jpg" {
                cell.photoImageView6.image = UIImage(named: "brak2.jpg")
            }else{
                 let bez_m = listaDan6[indexPath.row].foto.replacingOccurrences(of: "_m.", with: ".") //nazwa foto bez _m.
                //pobranie zdjęcia dania
                nh = Network()
                nh?.getPictureFromServer(imageName: bez_m, callback: { (image:UIImage)->Void in
                    DispatchQueue.main.async{
                        cell.photoImageView6.image = image
                    }
                })
            }
        }else{ //jeżeli nie ma Internetu
            cell.photoImageView6.image = UIImage(named: "brak2.jpg")//wczytanie zdjęcia tymczasowego
        }
        
        if Shared.shared.uz_id! != "" {
            //ikona uwaga - alergeny
            if listaDan6[indexPath.row].alergeny != "brak" {
                cell.uwaga6.image = UIImage(named: "uwaga.jpg")
            }else{
                cell.uwaga6.image = nil
            }
            
            //ikona ulubione
            if listaDan6[indexPath.row].fav == "1" {
                cell.ulubione6.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
                cell.ulubione6.tag = indexPath.row
                cell.ulubione6.addTarget(self, action: #selector(self.usun_ulubione), for: .touchUpInside)
            }else{
                cell.ulubione6.setImage(#imageLiteral(resourceName: "heartb"), for: .normal)
                cell.ulubione6.tag = indexPath.row
                cell.ulubione6.addTarget(self, action: #selector(self.dodaj_ulubione), for: .touchUpInside)
            }
        }
        
        return cell
    }
    
    //===============================
    //napis "Brak dań"
    //===============================
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if listaDan6.isEmpty{
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
        listaDan6[sender.tag].fav = "1"  //polubienie dania
        //update lubienia na serwerze cobytu.com
        let res = self.zmien_polubienie(da_id: String(listaDan6[sender.tag].daid), fav: "1")
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z polubionym daniem
            self.tableView6.reloadRows(at: [[0, sender.tag]], with: .none)
            //update polubienia dania w bazie lokalnej
            _ = StephencelisDB.instance.updateFavDania(daid: listaDan6[sender.tag].daid, fav: "1")
        }
    }
    
    //================================
    //usuń danie z ulubionych
    //================================
    @IBAction func usun_ulubione(_ sender: UIButton) {
        listaDan6[sender.tag].fav = "0"  //nie polubienie dania
        //update lubienia na serwerze cobytu.com
        let res = self.zmien_polubienie(da_id: String(listaDan6[sender.tag].daid), fav: "0")
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z polubionym daniem
            self.tableView6.reloadRows(at: [[0, sender.tag]], with: .none)
            //update polubienia dania w bazie lokalnej
            _ = StephencelisDB.instance.updateFavDania(daid: listaDan6[sender.tag].daid, fav: "0")
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
        let selectedIdDania = listaDan6[indexPath.row].daid
        
        //update id wybranego dania w bazie lokalnej - nowe id zapisane do tabeli 'memory'
        _ = StephencelisDB.instance.updateMemory(mem: "mem_danie", a: selectedIdDania, b: listaDan6[indexPath.row].foto, c: listaDan6[indexPath.row].alergeny, d: listaDan6[indexPath.row].nazwa, e: "", f: "")
        Shared.shared.wyborIdWersja = 0 //index pierwszego miejsca na liście wersji = 0
        //sprawdzenie dostępu do Internetu
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            performSegue(withIdentifier: "showDetails6", sender: self) //przejście do TabBarController
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

