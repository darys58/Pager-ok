//
//  OpinieViewController.swift
//  Pager
//
//  Created by darys on 01.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Floaty

class OpinieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var meal_opinie = [MealOpinie]()
    var ile_opinii = 0
   
    
    @IBOutlet weak var opinieTableView: UITableView!
    @IBOutlet weak var plusFloaty: Floaty!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opinieTableView.estimatedRowHeight = 175
        opinieTableView.rowHeight = UITableViewAutomaticDimension
        
        if Shared.shared.opinie.isEmpty {
            ile_opinii = 0
        }else{
            meal_opinie = Shared.shared.opinie
            ile_opinii = meal_opinie.count
        }
        
        if Shared.shared.uz_id != nil && Shared.shared.uz_id != ""{
            plusFloaty.addItem("L_DODAJ_OPINIE".localized(), icon: #imageLiteral(resourceName: "add_white"), handler: {_ in self.performSegue(withIdentifier: "sbDodajOpinie", sender: self)
             })
            plusFloaty.addItem("L_MOJE_OPINIE".localized(), icon: #imageLiteral(resourceName: "edit"), handler: {_ in self.performSegue(withIdentifier: "sbMojeOpinie", sender: self)
            })
        }else{
            plusFloaty.addItem(title: "L_ZALOGUJ_ABY_DODAC".localized())
        }
        
        
        
    }
    
    //usuwanie klawiatury z ekranu po naciśnięciu "Return" (działa przez delegata textField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        meal_opinie = Shared.shared.opinie  //przepisanie z pamięci podręcznej do zmiennej
        ile_opinii = meal_opinie.count
        self.opinieTableView.reloadData()
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ile_opinii
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "OpinieTableViewCell", for: indexPath) as! OpinieTableViewCell
        cell.starsView.rating = Double(self.meal_opinie[indexPath.row].op_srednia)!
        cell.autorLabel.text = self.meal_opinie[indexPath.row].op_autor
        cell.sredniaLabel.text = self.meal_opinie[indexPath.row].op_srednia
        cell.dodanoLabel.text = self.meal_opinie[indexPath.row].op_data_dod
        cell.tytulLabel.text = self.meal_opinie[indexPath.row].op_tytul
        //cell.trescTextView.text = self.meal_opinie[indexPath.row].op_tresc
        
        var opinia = ""
        switch self.meal_opinie[indexPath.row].op_wyglad{
            case "1": opinia += "L_WYGLAD_NIE".localized() + ". "
            case "2": opinia += "L_WYGLAD_KIE".localized() + ". "
            case "3": opinia += "L_WYGLAD_POP".localized() + ". "
            case "4": opinia += "L_WYGLAD_APE".localized() + ". "
            case "5": opinia += "L_WYGLAD_REW".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_smak{
            case "1": opinia += "L_SMAK_TRA".localized() + ". "
            case "2": opinia += "L_SMAK_NIE".localized() + ". "
            case "3": opinia += "L_SMAK_NAT".localized() + ". "
            case "4": opinia += "L_SMACZNE".localized() + ". "
            case "5": opinia += "L_SMAKUJE_WYS".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_zapach{
            case "1": opinia += "L_ZAPACH_TRA".localized() + ". "
            case "2": opinia += "L_BRAK_ZAPACHU".localized() + ". "
            case "3": opinia += "L_ZAPACH_NEU".localized() + ". "
            case "4": opinia += "L_PRZYJEMNY_ZAPACH".localized() + ". "
            case "5": opinia += "L_PACHNIE_REW".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_temp{
            case "1": opinia += "L_TEMP_NISKA".localized() + ". "
            case "2": opinia += "L_TEMP_WYSOKA".localized() + ". "
            case "3": opinia += "L_TEMP_DOBRA".localized() + ". "
            case "4": opinia += "L_TEMP_ODPOWIEDNIA".localized() + ". "
            case "5": opinia += "L_TEMP_IDEALNA".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_ilosc{
            case "1": opinia += "L_PORCJA_B_MALA".localized() + ". "
            case "2": opinia += "L_PORCJA_MALA".localized() + ". "
            case "3": opinia += "L_PORCJA_SREDNIA".localized() + ". "
            case "4": opinia += "L_PORCJA_WLASCIWA".localized() + ". "
            case "5": opinia += "L_PORCJA_DUZA".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_cena{
            case "1": opinia += "L_CENA_ZDE".localized() + ". "
            case "2": opinia += "L_CENA_TRO".localized() + ". "
            case "3": opinia += "L_CENA_WLA".localized() + ". "
            case "4": opinia += "L_TANIO".localized() + ". "
            case "5": opinia += "L_BARDZO_TANIO".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_opis{
            case "1": opinia += "L_OPIS1".localized() + ". "
            case "2": opinia += "L_OPIS2".localized() + ". "
            case "3": opinia += "L_OPIS3".localized() + ". "
            case "4": opinia += "L_OPIS4".localized() + ". "
            case "5": opinia += "L_OPIS5".localized() + ". "
        default: opinia += ""
        }
        switch self.meal_opinie[indexPath.row].op_foto{
            case "1": opinia += "L_ZDJECIE_1".localized() + ". "
            case "2": opinia += "L_ZDJECIE_2".localized() + ". "
            case "3": opinia += "L_ZDJECIE_3".localized() + ". "
            case "4": opinia += "L_ZDJECIE_4".localized() + ". "
            case "5": opinia += "L_ZDJECIE_5".localized() + ". "
        default: opinia += ""
        }
        if self.meal_opinie[indexPath.row].op_tresc == "" {
            cell.opiniaTextView.text = opinia
        }else {
            cell.opiniaTextView.text = self.meal_opinie[indexPath.row].op_tresc + " \n \(opinia)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "L_OPINIE_0_DANIU".localized() + ":"
    }
    // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //     return 180
    //}
}


