//
//  SearchTableVC.swift
//  Pager
//
//  Created by darys on 20.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit

class SearchTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var listaDan = [Mealdb]()           //lista dań pobrana z bazy
    var aktualnaListaDan = [Mealdb]()   //lista dań po przefiltrowaniu
    var nh: Network?                    //do pobierania zdjęć z sieci
    var reachability: Reachability?  //dostępność Internetu
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaDan = StephencelisDB.instance.getDaniaAll() //pobranie wszystkich dań z bazy
        aktualnaListaDan = listaDan //początkowy stan listy dań
        setUpSearchBar()
        alterLayout()
    }
    
    //usuwanie klawiatury z ekranu po naciśnięciu "Return" (działa przez delegata textField) - tu nie działa
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    private func setUpSearchBar() {
        searchbar.delegate = self
    }
    
    //nieruchomy pasek z polem wyszukiwarki
    func alterLayout() {
        table.tableHeaderView = UIView()
        //search bar in section header - uaktywnić konfiguracje sekcji tabeli poniżej
        //table.estimatedSectionHeaderHeight = 40
        //search bar in navigation bar
        navigationItem.titleView = searchbar
    }
    
    //wyszukiwarka
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else{
            aktualnaListaDan = listaDan
            table.reloadData()
            return
        }
        aktualnaListaDan = listaDan.filter({danie -> Bool in
            danie.nazwa.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aktualnaListaDan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchTableViewCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = aktualnaListaDan[indexPath.row].nazwa
        cell.restaLabel.text = aktualnaListaDan[indexPath.row].gdzie
        cell.cenaLabel.text = aktualnaListaDan[indexPath.row].cena + " PLN"
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            if listaDan[indexPath.row].foto == "co.jpg" {
                cell.imgView.image = UIImage(named: "brak2.jpg")
            }else{
                //pobranie zdjęcia dania
                nh = Network()
                nh?.getPictureFromServer(imageName: aktualnaListaDan[indexPath.row].foto, callback: { (image:UIImage)->Void in
                    DispatchQueue.main.async{
                        cell.imgView.image = image
                    }
                })
            }
        }//od sprawdzenia internetu
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // need when search bar in section header
    /*   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchbar
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
  */
    
    //========================
    //Zapamiętanie id wybranego (klikniętego) dania - dla widoku szczegółów
    //========================
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIdDania = aktualnaListaDan[indexPath.row].daid
        //print (selectedIdDania)
        //update id wybranego dania w bazie lokalnej - nowe id zapisane do tabeli 'memory'
        _ = StephencelisDB.instance.updateMemory(mem: "mem_danie", a: selectedIdDania, b: aktualnaListaDan[indexPath.row].foto, c: aktualnaListaDan[indexPath.row].alergeny, d: aktualnaListaDan[indexPath.row].nazwa, e: "", f: "")
        Shared.shared.wyborIdWersja = 0 //index pierwszego miejsca na liście wersji = 0
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            performSegue(withIdentifier: "showDetail", sender: self) //przejście do TabBarController
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


