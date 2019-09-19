//
//  StrefyViewController.swift
//  Pager
//
//  Created by darys on 11.11.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit

class CastomCellStrefy: UITableViewCell{
    
    @IBOutlet weak var strefaLabel: UILabel!
    @IBOutlet weak var strefyTextView: UITextView!
}


class StrefyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tytulLabel: UILabel!
    @IBOutlet weak var Popupview: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var anulujButton: UIButton!
    
    var strefy: [Strefa] = (Shared.shared.strefy)!
    var delegate: PopupDelegate3?  //3 zadeklarowanie delegata   //2 utworzenie protokołu PopupDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tytulLabel.text = "L_WRBIERZ_STREFE".localized()
        anulujButton.setTitle("L_ANULUJ".localized(), for: .normal)
        //== wyświetlenie popup
        Popupview.layer.cornerRadius = 10
        Popupview.layer.masksToBounds = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.strefy.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        Shared.shared.strefa = indexPath.row
        delegate?.popupValueSelected3(value: indexPath.row) //5 przekazanie dannych delegatowi
        //delegate?.popupValueSelected2(value: names[indexPath.row]) //5 przekazanie dannych delegatowi
        self.removeAnimate() //zamknięcie popup
        //Shared.shared.koszt = "5,00"  //trzeba go obliczać jakoś !!!
        //performSegue(withIdentifier: "sbDostawa", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CastomCellStrefy", for: indexPath) as! CastomCellStrefy
        cell.strefaLabel?.text = "L_STREFA".localized() + " " + String(indexPath.row + 1)
        cell.strefyTextView?.text = Shared.shared.strefy[indexPath.row].str_zakres
 
        return cell
    }
    
    
    
    
    //zamknięcie popup
    @IBAction func closePopup(_ sender: Any) {
        self.removeAnimate()
        
        //self.view.removeFromSuperview()
        //dismiss(animated: true, completion: nil)
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


