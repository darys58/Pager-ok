//
//  SettingsTableVC.swift
//  Pager
//
//  Created by darys on 09.04.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit

class SettingsTableVC: UITableViewController {

    @IBOutlet weak var listaWybor: UILabel!
    @IBOutlet weak var switchLista: UISwitch!
    @IBOutlet weak var ostrzezeniaLabel: UILabel!
    @IBOutlet weak var switchOstrzezenia: UISwitch!
    @IBOutlet weak var wersjaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titlelabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel
        titlelabel.text = "L_USTAWIENIA".localized()
        titlelabel.textAlignment = .center
        
        //ustawienie przełącznika listy
        listaWybor.text = "L_LISTA_Z_MALYMI".localized()
        if (Shared.shared.lista == "1"){
            switchLista.setOn(true, animated: false)
        }else{
            switchLista.setOn(false, animated: false)
        }
        
        //ustawienie oceny składników
        ostrzezeniaLabel.text = "L_OSTRZEZENIA".localized()
        if (Shared.shared.ostrzezenia == "1"){
            switchOstrzezenia.setOn(true, animated: false)
        }else{
            switchOstrzezenia.setOn(false, animated: false)
        }
        
        //ustawienia wersji
        wersjaLabel.text = "L_WERSJA".localized() +  ": " +  AppDelegate.wersja[0] + "." + AppDelegate.wersja[1] + "." + AppDelegate.wersja[2]
       
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = "Widok listy dań"
        if section == 0{
         title = "L_WIDOK_LISTY".localized()
        }
        if section == 1{
            title = "L_OCENA_SKLADNIKOW".localized()
        }
        if section == 2{
            title = "L_INFORMACJE".localized()
        }
        return title
        }
        
    

 
    @IBAction func exitButton(_ sender: UIBarButtonItem) {
           dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ostrzezenia(_ sender: UISwitch) {
        if(sender.isOn == true){
            //ustawienie pamięci ostrzeżenia
            Shared.shared.ostrzezenia = "1" //ostrzeżenia bedą wyświetlane
            //update ustawienia ostrzeżeń   -  do tabeli 'memory' rekord 'mem_app'
            _ = StephencelisDB.instance.updateMemory(mem: "mem_app", a: Shared.shared.lang, b: Shared.shared.lista, c: Shared.shared.ostrzezenia, d: "", e: "", f: "")
        }else{
            Shared.shared.ostrzezenia = "2" //bez ostrzeżeń
            //update ustawienia ostrzeżeń -  do tabeli 'memory' rekord 'mem_app'
            _ = StephencelisDB.instance.updateMemory(mem: "mem_app", a: Shared.shared.lang, b: Shared.shared.lista, c: Shared.shared.ostrzezenia, d: "", e: "", f: "")
        }
    }
    
    @IBAction func `switch`(_ sender: UISwitch) {
        if(sender.isOn == true){
            //ustawienie pamięci listy na 1 (czyli lista z małymi zdjęciami)
            Shared.shared.lista = "1"
            //update ustawienia listy -  do tabeli 'memory' rekord 'mem_app'
            _ = StephencelisDB.instance.updateMemory(mem: "mem_app", a: Shared.shared.lang, b: Shared.shared.lista, c: Shared.shared.ostrzezenia, d: "", e: "", f: "")
            //odświerz listę dań
            AppDelegate.refresh_list_meal = true
        }
        else{
            //ustawienie pamięci listy na 0 (czyli lista z dużymi zdjęciami)
            Shared.shared.lista = "0"
            //update ustawienia listy -  do tabeli 'memory' rekord 'mem_app'
            _ = StephencelisDB.instance.updateMemory(mem: "mem_app", a: Shared.shared.lang, b: Shared.shared.lista, c: Shared.shared.ostrzezenia, d: "", e: "", f: "")
            //odświerz listę dań
            AppDelegate.refresh_list_meal = true
        }
        print(Shared.shared.lista)
    }
    
    
    
 


}
