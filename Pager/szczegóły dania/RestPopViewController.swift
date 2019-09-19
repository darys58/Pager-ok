//
//  RestPopViewController.swift
//  Pager
//
//  Created by darys on 30.01.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit

class RestPopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var names: [String] = []
    var meal_resta = Shared.shared.restauracje  //pobranie danych restauracji z pamięci
    var rest_index = Shared.shared.facilities_rest_index //pobranie indexu restauracji z pamięci
    
    @IBOutlet weak var Popupview: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var anulujButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anulujButton.setTitle("L_ANULUJ".localized(), for: .normal)
        meal_resta = Shared.shared.restauracje  //pobranie danych restauracji z pamięci
        
        //==utworzenie tablicy z udogodnieniami do wyświetlenia
        if self.meal_resta![self.rest_index!].re_wifi == "1" {names.append("L_WIFI_TAK".localized())}
        if self.meal_resta![self.rest_index!].re_parking == "1" {names.append("L_PARKING_TAK".localized())}
        if self.meal_resta![self.rest_index!].re_klima == "1" {names.append("L_KLIMA_TAK".localized())}
        if self.meal_resta![self.rest_index!].re_p_karta == "1" {names.append("L_KARTA_TAK".localized())}
        if self.meal_resta![self.rest_index!].re_o_letni == "1" {names.append("L_OGRODEK_TAK".localized())}
        if self.meal_resta![self.rest_index!].re_na_wynos == "1" {names.append("L_WYNOS_TAK".localized())}
        if self.meal_resta![self.rest_index!].re_s_zabaw == "1" {names.append("L_STREFA_TAK".localized())}
        if self.meal_resta![self.rest_index!].re_podjazd == "1" {names.append("L_NIEPELNO_TAK".localized())}

        //== wyświetlenie popup
        Popupview.layer.cornerRadius = 10
        Popupview.layer.masksToBounds = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Arial", size: 16)
        cell.textLabel?.textColor = UIColor.gray
        cell.textLabel?.text = names[indexPath.row] //wypełnienie tabeli nazwami dodatków
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "L_UDOGODNIENIA".localized() + ":"
    }
    
    //==zamknięcie popup
    @IBAction func closePopup(_ sender: Any) {
        self.removeAnimate()
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if (finished){
                self.view.removeFromSuperview()
            }
            
        })
    }

}
