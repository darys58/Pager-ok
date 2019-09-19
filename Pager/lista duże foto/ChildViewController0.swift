//
//  ChildViewController0.swift - dania ulubione
//  Pager
//
//  Created by darys on 03.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
//import XLPagerTabStrip
import RestEssentials
import Localize_Swift

class ChildViewController0: UIViewController{
    
    @IBOutlet weak var tableView0: UITableView!
  
    
    var listaDan0 = [Mealdb]()  //DB lista dań
    var nh: Network? //do pobierania zdjęć z sieci
    var meal = [MealState]()
    var reachability: Reachability?  //dostępność Internetu
    
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var siec: Network?
    var memory1: [Memorydb]? = []         //filtry1 zapamiętane w bazie lokalnej
    var memory2: [Memorydb]? = []         //filtry2 zapamiętane w bazie lokalnej
    var activityIndicator = UIActivityIndicatorView() //wskaźnik aktywności
    
    
    //==============================
    //odświeżenie widoku listy dań
    //==============================
    lazy var refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(ChildViewController0.aktualizacjaDanych(_:)), for: .valueChanged)
        //refControl.tintColor = UIColor.red
        return refControl
    }()
    
    @objc func aktualizacjaDanych(_ refControl: UIRefreshControl){
        listaDan0 = StephencelisDB.instance.getDaniaFav() //pobranie ulubionych dań z bazy lokalnej (a trzeba z sieci)
        self.tableView0.reloadData()
        refControl.endRefreshing()
    }
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "L_ULUBIONE".localized()
        
        listaDan0 = StephencelisDB.instance.getDaniaFav() //pobranie dań z bazy
        Shared.shared.podkategoria = "" //kasowanie ustawień filtrowania po podkategorii
        
        
        self.tableView0.addSubview(self.refreshControl)

        //----- wskaźnik aktywności-----------
        activityIndicator.center = CGPoint.init(x: self.view.frame.size.width/2, y: 200)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        self.activityIndicator.stopAnimating()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        if AppDelegate.refresh_list_meal{   //jeżeli jest 'true' to odśwież listę dań...
            if AppDelegate.lubienie_zmienione == true { //jeżeli zmieniono oceny składników
                getDataFromServer()
            }
        }
    }
    
    
}

//====================================
//wyświetlenie dań w widoku tabeli z daniami
//====================================
extension ChildViewController0: UITableViewDataSource, UITableViewDelegate {
    
    //ilość sekcji w tabeli
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //ilość wierszy w tabeli
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaDan0.count
    }
    
    //konfigurowanie celi (wiersza tabeli)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        //pobranie komórki z tabeli
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Meal0TableViewCell", for: indexPath) as? Meal0TableViewCell else {
            fatalError("Komórka nie jest instancją Meal0TableViewCell")
        }

        let circleLabel: UILabel = {
            let label = UILabel()
            //label.text = "100"
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
        
        cell.starsView.rating = Double(listaDan0[indexPath.row].srednia)!
        cell.starsView.text = listaDan0[indexPath.row].srednia
        //załadowanie danych dań
        cell.nameLabel0.text = listaDan0[indexPath.row].nazwa
        //cell.cenaLabel0.text = listaDan0[indexPath.row].cena
        //formatowanie i wyświetlanie ceny
        if listaDan0[indexPath.row].cena != "wr"{
            let numCena = formatter1.string(from: NSNumber(value: Float(listaDan0[indexPath.row].cena)!))
            cell.cenaLabel0.text = "\(numCena! ) " + "L_PLN".localized()//cena menu + opakowania
        }else{
            cell.cenaLabel0.text = listaDan0[indexPath.row].cena
        }
        cell.czasLabel0.text = "\(listaDan0[indexPath.row].czas) " + "L_MIN".localized()
        cell.wagaLabel0.text = "\(listaDan0[indexPath.row].waga) " + "L_G".localized()
        cell.kcalLabel0.text = "\(listaDan0[indexPath.row].kcal) " + "L_KCAL".localized()
        
        if listaDan0[indexPath.row].lubi != "0"{
            let lubienie = Float(listaDan0[indexPath.row].lubi)
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
            circleLabel.text = listaDan0[indexPath.row].lubi
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
                circleLabel.text = listaDan0[indexPath.row].lubi
                cell.addSubview(circleLabel)
                circleLabel.frame = CGRect(x: 25, y: 78, width: 45, height: 45)
            }
        }
        
        //sprawdzenie dostępu do Internetu
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            if listaDan0[indexPath.row].foto == "co.jpg" {
                cell.photoImageView0.image = UIImage(named: "brak2.jpg")
            }else{
                 let bez_m = listaDan0[indexPath.row].foto.replacingOccurrences(of: "_m.", with: ".") //nazwa foto bez _m.
                //pobranie zdjęcia dania
                nh = Network()
                nh?.getPictureFromServer(imageName: bez_m, callback: { (image:UIImage)->Void in
                    DispatchQueue.main.async{
                        cell.photoImageView0.image = image
                    }
                })
            }
        }else{ //jeżeli nie ma Internetu
            cell.photoImageView0.image = UIImage(named: "brak2.jpg")//wczytanie zdjęcia tymczasowego
        }
        
        //ikona uwaga - alergeny
        if listaDan0[indexPath.row].alergeny != "brak" {
            cell.uwaga0.image = UIImage(named: "uwaga.jpg")
        }else{
            cell.uwaga0.image = nil
        }
        
        //ikona ulubione
        if listaDan0[indexPath.row].fav == "1" {
            cell.ulubione0.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            cell.ulubione0.tag = indexPath.row
            cell.ulubione0.addTarget(self, action: #selector(self.usun_ulubione), for: .touchUpInside)
        }else{
            cell.ulubione0.setImage(#imageLiteral(resourceName: "heartb"), for: .normal)
            cell.ulubione0.tag = indexPath.row
            cell.ulubione0.addTarget(self, action: #selector(self.dodaj_ulubione), for: .touchUpInside)
        }
        
        return cell
    }
    
    //===============================
    //napis "Brak dań"
    //===============================
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if listaDan0.isEmpty{
            return 70
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "L_BRAK_DAN_ULUBIONYCH".localized()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    //================================
    //dodaj danie do ulubionych
    //================================
    @IBAction func dodaj_ulubione(_ sender: UIButton) {
        listaDan0[sender.tag].fav = "1"  //polubienie dania
        //update lubienia na serwerze cobytu.com
        let res = self.zmien_polubienie(da_id: String(listaDan0[sender.tag].daid), fav: "1")
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z polubionym daniem
            self.tableView0.reloadRows(at: [[0, sender.tag]], with: .none)
            //update polubienia dania w bazie lokalnej
            _ = StephencelisDB.instance.updateFavDania(daid: listaDan0[sender.tag].daid, fav: "1")
        }
    }
    
    //================================
    //usuń danie z ulubionych
    //================================
    @IBAction func usun_ulubione(_ sender: UIButton) {
        listaDan0[sender.tag].fav = "0"  //odlubienie dania
        //update lubienia na serwerze cobytu.com
        let res = self.zmien_polubienie(da_id: String(listaDan0[sender.tag].daid), fav: "0")
        
        if res == 1 { //jeżeli udało się zapisać zmiany na serwerze
            //odświeżenie celi z polubionym daniem
            self.tableView0.reloadRows(at: [[0, sender.tag]], with: .none)
            
            //update polubienia dania w bazie lokalnej
            _ = StephencelisDB.instance.updateFavDania(daid: listaDan0[sender.tag].daid, fav: "0")
            
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
    
    //---------------------------------------
    //pobranie aktualnych danych z serwera
    //---------------------------------------
    func getDataFromServer(){
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            siec = Network()
            
            //----- wskaźnik aktywności-----------
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            //-------------------------------------
            
            //zaremowane bo nie zdąża załadować wszystkich resatauracji i wychodzi że wybranej resta nie ma
            //skasowanie wszystkich restauracji z tabeli 'restauracje'
            //           _ = StephencelisDB.instance.deleteRestauracjeAll()
            
            //wczytanie wszystkich restauracji
            //           siec!.importujRestauracje()
            
            //skasowanie wszystkich podkategorii z tabeli 'podkategorie'
            //           _ = StephencelisDB.instance.deletePodkategorieAll()
            
            //wczytanie wszystkich podkategorii
            //           siec!.importujPodkategorie()
            
            //wczytanie (update) aktualnych wartości filtrów z www
            //           siec!.importujFiltr()
            
            //skasowanie wszystkich dań z tabeli 'dania'
            _ = StephencelisDB.instance.deleteDaniaAll()
            
            
            //pobranie lokalizacji z tabeli 'memory->mem_lok'
            location = StephencelisDB.instance.getMemory(memo: "mem_lok")
            //print("location=")
            //print(location!)
            //== pobranie danych filtrów z tabeli 'memory'
            //mem_filtr1 (a:czasmin, b:czasmax, c:wagamin, d:wagamax, e:kcalmin, f:kcalma)
            memory1 = StephencelisDB.instance.getMemory(memo: "mem_filtr1")
            //mem_filtr2 (a:cenamin, b:cenamax, c:dla
            memory2 = StephencelisDB.instance.getMemory(memo: "mem_filtr2")
            
            var res: Int //czy powiódł się import Dań
            //czy jest restauracja? bo jeśli nie to załaduj domyślne (wszystkie z Konina)
            if location![0].e != "0" { //jeżeli aktualnie nie są wybrane "Wszystkie" rest w mieście
                let czy_jest_rest = StephencelisDB.instance.czyRestauracja(rest: location![0].e)
                
                if czy_jest_rest > 0{ //wybrana restauracja istnieje w bazie (czy_jest_rest = 1)
                    res = (siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())"))!
                }else{ //restauracji nie ma już w bazie www (bo np. została usunięta) - ładuje domyślne
                    res = (siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=14&mia_id=1&rest=0&lang=\(Localize.currentLanguage())"))!
                }
            }else{ //są wybrane "Wszystkie" w wybranym mieście
                //pobranie dań dla wszystkich restauracji w miescie (bez filtrów bo skasowane i uaktualnione)
                res = (siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())"))!
            }
            
            if res == 1 {
                AppDelegate.lubienie_zmienione = false  //pobrano aktualne oceny składników - lubienie altualne
                
                //opóźnienie żeby zdążyło przeładować dane
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.listaDan0 = StephencelisDB.instance.getDaniaFav() //pobranie dań z bazy
                    self.tableView0.reloadData()// - odświeżenie widoku ??
                }
            }
            
        }else{ //jeżeli nie ma Internetu
            displayAlert()
        }
        
    }
    

    //========================
    //Zapamiętanie id wybranego (klikniętego) dania - dla widoku szczegółów
    //========================
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIdDania = listaDan0[indexPath.row].daid
        
        //update id wybranego dania w bazie lokalnej - nowe id zapisane do tabeli 'memory'
        _ = StephencelisDB.instance.updateMemory(mem: "mem_danie", a: selectedIdDania, b: listaDan0[indexPath.row].foto, c: listaDan0[indexPath.row].alergeny, d: listaDan0[indexPath.row].nazwa, e: "", f: "")
        Shared.shared.wyborIdWersja = 0 //index pierwszego miejsca na liście wersji = 0
        //sprawdzenie dostępu do Internetu
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            performSegue(withIdentifier: "showDetails0", sender: self) //przejście do TabBarController
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
