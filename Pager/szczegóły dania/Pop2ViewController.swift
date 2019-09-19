//
//  Pop2ViewController.swift
//  Pager
//
//  Created by darys on 18.01.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit

class Pop2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var Popupview: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var anulujButton: UIButton!
    
    var names: [String] = (Shared.shared.lista_wariant2)!
    var delegate: PopupDelegate2?  //3 zadeklarowanie delegata   //2 utworzenie protokołu PopupDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anulujButton.setTitle("L_ANULUJ".localized(), for: .normal)
        //== wyświetlenie popup
        Popupview.layer.cornerRadius = 10
        Popupview.layer.masksToBounds = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.popupValueSelected2(value: indexPath.row) //5 przekazanie dannych delegatowi
        //delegate?.popupValueSelected2(value: names[indexPath.row]) //5 przekazanie dannych delegatowi
        self.removeAnimate() //zamknięcie popup
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Arial", size: 18)
        cell.textLabel?.textColor = UIColor.gray
        cell.textLabel?.text = names[indexPath.row] //wypełnienie tabeli nazwami dodatków
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


