//
//  PowiadomieniaVC.swift
//  Pager
//
//  Created by darys on 22.08.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit

class PowiadomCell: UITableViewCell{
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var restaLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var tytulLabel: UILabel!
    @IBOutlet weak var trescTextView: UITextView!
    
}

class PowiadomieniaVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var listaDanReklamowanych = [Mealdb]()  //DB lista dań
    var reachability: Reachability?  //dostępność Internetu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tytuł ekranu
        let titlelabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel1
        titlelabel1.text = "L_PROMOCJE".localized()
        titlelabel1.textAlignment = .center
        
    
    }

   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shared.shared.powiadomienia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PowiadomCell", for: indexPath) as? PowiadomCell else {
            fatalError("Komórka nie jest instancją PowiadomCell")
        }
        //żeby nie znikało tło pod napisami po wybraniu celi
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if Shared.shared.powiadomienia[indexPath.row].rb_da_id != ""{
            if Shared.shared.powiadomienia[indexPath.row].rb_da_id != "0"{
                print(" id \(Shared.shared.powiadomienia[indexPath.row].rb_da_id)")
                cell.infoLabel.text = "L_MENU".localized()
            }else{
                cell.infoLabel.text = "L_INFO".localized()
            }
        }
        cell.restaLabel.text = Shared.shared.powiadomienia[indexPath.row].rb_resta
        cell.dataLabel.text = Shared.shared.powiadomienia[indexPath.row].rb_data_mod
        cell.tytulLabel.text = Shared.shared.powiadomienia[indexPath.row].rb_tytul
        cell.trescTextView.text = Shared.shared.powiadomienia[indexPath.row].rb_opis
        
        return cell
    }

    //========================
    //Zapamiętanie id wybranego (klikniętego) dania - dla widoku szczegółów
    //========================
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIdDania = Shared.shared.powiadomienia[indexPath.row].rb_da_id
        if selectedIdDania != "0"{
            var danie = [Mealdb]() //danie z bazy lokalnej
            danie = StephencelisDB.instance.getDanie(id: selectedIdDania) //pobranie dania z bazy lokalnej
            print("id dania = \(selectedIdDania)")
            print(danie)
            if danie.isEmpty{
                    print("pusto")
            }else{
                //update id wybranego dania w bazie lokalnej - nowe id zapisane do tabeli 'memory'
                _ = StephencelisDB.instance.updateMemory(mem: "mem_danie", a: selectedIdDania, b: danie[0].foto, c: danie[0].alergeny, d: danie[0].nazwa, e: "", f: "")
            
                //sprawdzenie dostępu do Internetu
                self.reachability = Reachability.init()
                if((self.reachability!.connection) != .none){ //jeżeli jest Internet
                    performSegue(withIdentifier: "sbTab1Powiadom", sender: self) //przejście do TabBarController
                }else{ //jeżeli nie ma Internetu
                    displayAlert()
                }
            }
        }
    }
    
    // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   //     return 110
   // }
    
    //komunikat "Brak Internetu"
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }

}
