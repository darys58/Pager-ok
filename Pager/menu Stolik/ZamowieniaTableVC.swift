//
//  ZamowieniaTableVC.swift
//  Pager
//
//  Created by darys on 20.06.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Localize_Swift

class ZamowieniaCell: UITableViewCell{
    @IBOutlet weak var zamCell1Label: UILabel!
    @IBOutlet weak var szczegolyCell1Label: UILabel!
    @IBOutlet weak var wartoscCell1Label: UILabel!
    @IBOutlet weak var ikonaCell1Image: UIImageView!
    @IBOutlet weak var cell1View: UIView!
}

class DoStolikaCell: UITableViewCell{
    @IBOutlet weak var doStolCell2Label: UILabel!
    @IBOutlet weak var wartoscCell2Label: UILabel!
    @IBOutlet weak var ikonaCell2Image: UIImageView!
    @IBOutlet weak var cell2View: UIView!
}


class ZamowieniaTableVC: UITableViewController {

    var zamAktualne = [Zamowienie]()  //tablica zamówień
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tytuł ekranu
        let titlelabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel1
        titlelabel1.text = "L_ZAMOWIENIA".localized()
        titlelabel1.textAlignment = .center
        
        //ze wszystkich zamówień zalogowanego wybierane są tylko aktualne
        //bez załatwionych i zarchiwizowanych
        for zam in Shared.shared.zamowienia{
            if zam.za_status_id != "80" && zam.za_status_id != "90"{
                zamAktualne.append(zam)  //tablica zamówień aktualnych
            }
        }
    
    
    }
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zamAktualne.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if zamAktualne[indexPath.row].za_typ == "2" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DoStolikaCell", for: indexPath) as? DoStolikaCell else {
                fatalError("Komórka nie jest instancją DoStolikaCell")
            }
            //żeby nie znikało tło pod napisami po wybraniu celi
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.doStolCell2Label.text = zamAktualne[indexPath.row].za_typ_text + " " + zamAktualne[indexPath.row].za_data
            
            //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
            let formatter1 = NumberFormatter() //deklaracja obiektu formatera
            formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
            formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
            let numCena = formatter1.string(from: NSNumber(value: Float(zamAktualne[indexPath.row].cena_razem)!))

            cell.wartoscCell2Label.text = "L_WARTOSC_ZAMOWIENIA".localized() + ": " + numCena! + " " + "L_PLN".localized()
            
            cell.ikonaCell2Image.image = UIImage(named: "jedzenie.png")
            cell.cell2View.layer.cornerRadius = 5.0
            
            switch zamAktualne[indexPath.row].za_status_id{
                case "0": cell.cell2View.backgroundColor = Shared.shared.status0
                case "1": cell.cell2View.backgroundColor = Shared.shared.status1
                case "2": cell.cell2View.backgroundColor = Shared.shared.status2_3_31
                case "3": cell.cell2View.backgroundColor = Shared.shared.status2_3_31
                case "31": cell.cell2View.backgroundColor = Shared.shared.status2_3_31
                case "4": cell.cell2View.backgroundColor = Shared.shared.status4_5_51
                case "5": cell.cell2View.backgroundColor = Shared.shared.status4_5_51
                case "51": cell.cell2View.backgroundColor = Shared.shared.status4_5_51
                case "6": cell.cell2View.backgroundColor = Shared.shared.status6_7_71
                case "7": cell.cell2View.backgroundColor = Shared.shared.status6_7_71
                case "71": cell.cell2View.backgroundColor = Shared.shared.status6_7_71
                case "80": cell.cell2View.backgroundColor = Shared.shared.status80
                case "90": cell.cell2View.backgroundColor = Shared.shared.status90
            default:
                cell.cell2View.backgroundColor = Shared.shared.status90
            }
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ZamowieniaCell", for: indexPath) as? ZamowieniaCell else {
                fatalError("Komórka nie jest instancją ZamowieniaCell")
            }
            //żeby nie znikało tło pod napisami po wybraniu celi
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.zamCell1Label.text = zamAktualne[indexPath.row].za_typ_text + " " + zamAktualne[indexPath.row].za_data
            
            if zamAktualne[indexPath.row].za_typ == "1"{
                cell.szczegolyCell1Label.text = "L_NA_GODZ".localized() + " " + zamAktualne[indexPath.row].za_godz
            }else{
                cell.szczegolyCell1Label.text = "L_NA_GODZ".localized() + " " + zamAktualne[indexPath.row].za_godz + " " + "L_STOLIK_DLA".localized() + ": " + zamAktualne[indexPath.row].za_miejsc
            }
            
            //do formatowania ceny i kosztów - liczba z dwoma miejscami po przecinku
            let formatter1 = NumberFormatter() //deklaracja obiektu formatera
            formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
            formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
            let numCena = formatter1.string(from: NSNumber(value: Float(zamAktualne[indexPath.row].cena_razem)!))
            
            
            cell.wartoscCell1Label.text = "L_WARTOSC_ZAMOWIENIA".localized() + ": " + numCena! + " " + "L_PLN".localized()
            
            if zamAktualne[indexPath.row].za_typ == "1"{
                cell.ikonaCell1Image.image = UIImage(named: "dostawa.png")
            }else{
                cell.ikonaCell1Image.image = UIImage(named: "rezerwacja.png")
            }
            cell.cell1View.layer.cornerRadius = 5.0

            switch zamAktualne[indexPath.row].za_status_id{
                case "0": cell.cell1View.backgroundColor = Shared.shared.status0
                case "1": cell.cell1View.backgroundColor = Shared.shared.status1
                case "2": cell.cell1View.backgroundColor = Shared.shared.status2_3_31
                case "3": cell.cell1View.backgroundColor = Shared.shared.status2_3_31
                case "31": cell.cell1View.backgroundColor = Shared.shared.status2_3_31
                case "4": cell.cell1View.backgroundColor = Shared.shared.status4_5_51
                case "5": cell.cell1View.backgroundColor = Shared.shared.status4_5_51
                case "51": cell.cell1View.backgroundColor = Shared.shared.status4_5_51
                case "6": cell.cell1View.backgroundColor = Shared.shared.status6_7_71
                case "7": cell.cell1View.backgroundColor = Shared.shared.status6_7_71
                case "71": cell.cell1View.backgroundColor = Shared.shared.status6_7_71
                case "80": cell.cell1View.backgroundColor = Shared.shared.status80
                case "90": cell.cell1View.backgroundColor = Shared.shared.status90
                default:
                    cell.cell1View.backgroundColor = Shared.shared.status90
            }
            return cell
        }
        
    }
    
    //========================
    //Zapamiętanie id wybranego (klikniętego) zamówienia - dla widoku szczegółów
    //========================
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Shared.shared.selectedIdZamowienia = zamAktualne[indexPath.row].za_id
        
        //pobranie dań dla wybranego zamówienia
        self.downloadJSON_zam{
            
            self.performSegue(withIdentifier: "sbSzczegolyZam", sender: self) //przejście do
        }
    
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if zamAktualne[indexPath.row].za_typ == "2"{
            return 80
        }else{
            return 100
        }
    }
  
    //=========================================================
    //funkcja pobierająca JSONa z daniami do zamówienia (dla wyswietlenia jego szczegółów)
    //=========================================================
    func downloadJSON_zam(completed: @escaping () -> ()) {
        //pobranie lokalizacji z tabeli 'memory->mem_lok'
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_dania_zamowienia&uz_id=\(Shared.shared.uz_id!)&re=\(location![0].e)&za_id=\(Shared.shared.selectedIdZamowienia!)&lang=\(Localize.currentLanguage())")
        //print(url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    //print(data)
                    Shared.shared.zamowioneDania = try JSONDecoder().decode([DanieZamowione].self, from: data!)
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
