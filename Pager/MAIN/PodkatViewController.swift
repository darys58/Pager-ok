//
//  PodkatViewController.swift
//  Pager
//
//  Created by darys on 17.03.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit

class PodkatViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var Popupview: UIView!
    @IBOutlet weak var anulujButton: UIButton!
    @IBOutlet weak var zatwierdzButton: UIButton!
    @IBOutlet weak var kategoriaLabel: UILabel!
    
    var pickerView = UIPickerView()
    var podkategorie = [String]()  //nazwy podkategorii dla wybranej kategorii
    var podkategoria = [Podkategoriedb]() //dane podkategorii o wybranej nazwie
    
    override func viewDidLoad() {
        super.viewDidLoad()

        anulujButton.setTitle("L_ANULUJ".localized(), for: .normal)
        zatwierdzButton.setTitle("L_ZATWIERDZ".localized(), for: .normal)
        
        switch AppDelegate.which_page{
            case 9: kategoriaLabel.text = "L_SNIADANIA".localized()
            case 1: kategoriaLabel.text = "L_PRZYSTAWKI".localized()
            case 2: kategoriaLabel.text = "L_ZUPY".localized()
            case 3: kategoriaLabel.text = "L_SALATKI".localized()
            case 4: kategoriaLabel.text = "L_DANIA_GLOWNE".localized()
            case 5: kategoriaLabel.text = "L_DLA_DZIECI".localized()
            case 6: kategoriaLabel.text = "L_DESERY".localized()
            case 7: kategoriaLabel.text = "L_NAPOJE".localized()
            case 8: kategoriaLabel.text = "L_ALKOHOLE".localized()
        default:
            break
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //== wyświetlenie popup
        Popupview.layer.cornerRadius = 10
        Popupview.layer.masksToBounds = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
        
        //wyświetlenie pickera
        pickerView.frame = CGRect(x: 0, y: 0, width: 250, height: 300)
        //pickerView.backgroundColor = Shared.shared.malinaColor
        pickerView.center = self.view.center
        self.view.addSubview(pickerView)

        //pobranie podkategorii dla bierzącej kategorii
        podkategorie = StephencelisDB.instance.getPodkategorie(kaid: String(AppDelegate.which_page))
    }
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return podkategorie.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var titlePodkat = podkategorie[row]
        if titlePodkat == "00" {titlePodkat = "L_WSZYSTKIE".localized()}
        return titlePodkat
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if podkategorie[row] != "00"{
            //pobranie podkategorii dla wybranej nazwy
            podkategoria = StephencelisDB.instance.getPodkategoriaId(nazwa: podkategorie[row])
            //print (podkategoria[0].pkid)
            //zapisanie id podkategorii w pamięci podręcznej
            Shared.shared.podkategoria = podkategoria[0].pkid
        }else{
            Shared.shared.podkategoria = ""  //wybrano "Wszystkie"
        }
    }

    
    
    //zatwierdzenie wyboru podkategorii
    @IBAction func zatwierdzenie(_ sender: UIButton) {
        
        AppDelegate.refresh_list_meal = true
        
        //przejście do strony głównej
        self.performSegue(withIdentifier: "unwindToParentFromPodkat", sender: self)
        self.removeAnimate()
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
        Shared.shared.temp = 0
       
        
    }

}
