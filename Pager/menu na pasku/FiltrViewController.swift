//
//  FiltrViewController.swift
//  Pager
//
//  Created by darys on 13.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import DLRadioButton
import Localize_Swift

class FiltrViewController: UIViewController {
    
    @IBOutlet weak var zatwierdzButton: UIBarButtonItem!
    @IBOutlet weak var czasTitleLabel: UILabel!
    @IBOutlet weak var czasLabel: UILabel!
    @IBOutlet weak var czasSlider: RangeSlider!
    @IBOutlet weak var wagaTitleLabel: UILabel!
    @IBOutlet weak var wagaSlider: RangeSlider!
    @IBOutlet weak var wagaRangeLabel: UILabel!
    @IBOutlet weak var kcalTitleLabel: UILabel!
    @IBOutlet weak var kcalRangeLabel: UILabel!
    @IBOutlet weak var kcalSlider: RangeSlider!
    @IBOutlet weak var cenaTitleLabel: UILabel!
    @IBOutlet weak var cenaRangeLabel: UILabel!
    @IBOutlet weak var cenaSlider: RangeSlider!
    
    @IBOutlet weak var noLimitRadioButton: DLRadioButton!
    @IBOutlet weak var onePersonRadioButton: DLRadioButton!
    @IBOutlet weak var twoPersonRadioButton: DLRadioButton!
    @IBOutlet weak var morePersonRadioButton: DLRadioButton!
    
    var memory1_0: [Memorydb]? = []        //dane zapamiętane w bazie lokalnej
    var memory2_0: [Memorydb]? = []
    var memory1: [Memorydb]? = []
    var memory2: [Memorydb]? = []
    var siec: Network?
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    
    var activityIndicator = UIActivityIndicatorView()
    var reachability: Reachability?  //dostępność Internetu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zatwierdzButton.title = "L_ZATWIERDZ".localized()
        navigationItem.title = "L_FILTRY".localized()
        
        //== pobranie danych filtrów z tabeli 'memory'
        //mem_filtr1_0 (a:czasmin, b:czasmax, c:wagamin, d:wagamax, e:kcalmin, f:kcalma)
        memory1_0 = StephencelisDB.instance.getMemory(memo: "mem_filtr1_0")
        //mem_filtr2_0 (a:cenamin, b:cenamax, c:dla
        memory2_0 = StephencelisDB.instance.getMemory(memo: "mem_filtr2_0") //a:
        //mem_filtr1 (a:czasmin, b:czasmax, c:wagamin, d:wagamax, e:kcalmin, f:kcalma)
        memory1 = StephencelisDB.instance.getMemory(memo: "mem_filtr1")
        //mem_filtr2 (a:cenamin, b:cenamax, c:dla
        memory2 = StephencelisDB.instance.getMemory(memo: "mem_filtr2")
        //print ("memory w filtr =\(memory2![0].c)")
        
        czasSlider.minimumValue = Double(memory1_0![0].a)!
        czasSlider.maximumValue = Double(memory1_0![0].b)!
        czasSlider.lowerValue = Double(memory1![0].a)!
        czasSlider.upperValue  = Double(memory1![0].b)!
        czasTitleLabel.text = "L_CZAS".localized() + ": "
        czasLabel.text = "L_OD".localized() + " \(memory1![0].a) " + "L_DO".localized() + " \(memory1![0].b)" + " min"
        
        wagaSlider.minimumValue = Double(memory1_0![0].c)!
        wagaSlider.maximumValue = Double(memory1_0![0].d)!
        wagaSlider.lowerValue = Double(memory1![0].c)!
        wagaSlider.upperValue  = Double(memory1![0].d)!
        wagaTitleLabel.text = "L_ILOSC".localized() + ": "
        wagaRangeLabel.text = "L_OD".localized() + " \(memory1![0].c) " + "L_DO".localized() + " \(memory1![0].d)" + " g/ml"
        
        kcalSlider.minimumValue = Double(memory1_0![0].e)!
        kcalSlider.maximumValue = Double(memory1_0![0].f)!
        kcalSlider.lowerValue = Double(memory1![0].e)!
        kcalSlider.upperValue  = Double(memory1![0].f)!
        kcalTitleLabel.text = "L_ENERGIA".localized() + ": "
        kcalRangeLabel.text = "L_OD".localized() + " \(memory1![0].e) " + "L_DO".localized() + "  \(memory1![0].f)" + " kcal"
        
        cenaSlider.minimumValue = Double(memory2_0![0].a)!
        cenaSlider.maximumValue = Double(memory2_0![0].b)!
        cenaSlider.lowerValue = Double(memory2![0].a)!
        cenaSlider.upperValue  = Double(memory2![0].b)!
        cenaTitleLabel.text = "L_CENA".localized() + ": "
        cenaRangeLabel.text = "L_OD".localized() + " \(memory2![0].a) " + "L_DO".localized() + " \(memory2![0].b)" + " PLN"
        
        let dla = memory2![0].c
        switch dla {
            case "0": noLimitRadioButton.isSelected = true
            case "1": onePersonRadioButton.isSelected = true
            case "2": twoPersonRadioButton.isSelected = true
            case "3": morePersonRadioButton.isSelected = true
        default: noLimitRadioButton.isSelected = true
        }
        
        //wskaźnik aktywności
        activityIndicator.center = self.view.center //CGPoint.init(x: self.view.frame.size.width/2, y: 200)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
    }
    
    //Suwaki
    @IBAction func czasRangeSlider(_ sender: RangeSlider) {
        czasLabel.text = "L_OD".localized() + " \(String(format: "%.0f",(sender.lowerValue))) " + "L_DO".localized() + " \(String(format: "%.0f",(sender.upperValue))) min"
    }
    @IBAction func range(_ sender: RangeSlider) {
        wagaRangeLabel.text = "L_OD".localized() + " \(String(format: "%.0f",(sender.lowerValue))) " + "L_DO".localized() + " \(String(format: "%.0f",(sender.upperValue)))" + " g/ml"
    }
    
    @IBAction func kcakRangeSlider(_ sender: RangeSlider) {
        kcalRangeLabel.text = "L_OD".localized() + " \(String(format: "%.0f",(sender.lowerValue))) " + "L_DO".localized() + " \(String(format: "%.0f",(sender.upperValue))) kcal"
    }
    @IBAction func cenaRangeSlider(_ sender: RangeSlider) {
        cenaRangeLabel.text = "L_OD".localized() + " \(String(format: "%.0f",(sender.lowerValue))) " + "L_DO".localized() + " \(String(format: "%.0f",(sender.upperValue))) PLN"
    }
    
    //Filtruj
    @IBAction func filtrujButton(_ sender: UIBarButtonItem) {
        //sprawdzenie dostępu do Internetu
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            //zapamiętanie w bazie lokalnej ustawień filtra
            _ = StephencelisDB.instance.updateMemory(mem: "mem_filtr1", a: String(format: "%.0f",(czasSlider.lowerValue)), b: String(format: "%.0f",(czasSlider.upperValue)), c: String(format: "%.0f",(wagaSlider.lowerValue)), d: String(format: "%.0f",(wagaSlider.upperValue)), e: String(format: "%.0f",(kcalSlider.lowerValue)), f: String(format: "%.0f",(kcalSlider.upperValue)))
            
            var dla_set = "0"
            if noLimitRadioButton.isSelected {
                dla_set = "0"
            }else if onePersonRadioButton.isSelected {
                dla_set = "1"
            }else if twoPersonRadioButton.isSelected {
                dla_set = "2"
            }else if morePersonRadioButton.isSelected {
                dla_set = "3"
            }
            
            _ = StephencelisDB.instance.updateMemory(mem: "mem_filtr2", a: String(format: "%.0f",(cenaSlider.lowerValue)), b: String(format: "%.0f",(cenaSlider.upperValue)), c: dla_set, d: "", e: "", f: "")
            
            //zerowanie tabeli 'dania' w bazie lokalnej
            _ = StephencelisDB.instance.deleteDaniaAll()
            
            //pobranie lokalizacji z tabeli 'memory->mem_lok'
            location = StephencelisDB.instance.getMemory(memo: "mem_lok")
            
            //pobranie dań z serwera dla wybranej restauracji
            siec = Network()
            if Shared.shared.uz_id != nil {
                _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&dla=\(dla_set)&czasmin=\(String(format: "%.0f",(czasSlider.lowerValue)))&czasmax=\(String(format: "%.0f",(czasSlider.upperValue)))&cenamin=\(String(format: "%.0f",(cenaSlider.lowerValue)))&cenamax=\(String(format: "%.0f",(cenaSlider.upperValue)))&wagamin=\(String(format: "%.0f",(wagaSlider.lowerValue)))&wagamax=\(String(format: "%.0f",(wagaSlider.upperValue)))&kcalmin=\(String(format: "%.0f",(kcalSlider.lowerValue)))&kcalmax=\(String(format: "%.0f",(kcalSlider.upperValue)))&lang=\(Localize.currentLanguage())")//\(Shared.shared.lang)
            }else{
                _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&dla=\(dla_set)&czasmin=\(String(format: "%.0f",(czasSlider.lowerValue)))&czasmax=\(String(format: "%.0f",(czasSlider.upperValue)))&cenamin=\(String(format: "%.0f",(cenaSlider.lowerValue)))&cenamax=\(String(format: "%.0f",(cenaSlider.upperValue)))&wagamin=\(String(format: "%.0f",(wagaSlider.lowerValue)))&wagamax=\(String(format: "%.0f",(wagaSlider.upperValue)))&kcalmin=\(String(format: "%.0f",(kcalSlider.lowerValue)))&kcalmax=\(String(format: "%.0f",(kcalSlider.upperValue)))&lang=\(Localize.currentLanguage())")//\(Shared.shared.lang)
            }
            
            
            //zwłoka na pobranie danych z Internetu
            activityIndicator.startAnimating()
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in UIApplication.shared.endIgnoringInteractionEvents()
                
                //Zwłoka do czasu pobrania wszystkich dań z internetu do bazy lokalnej
                var aaa = 0
                while Shared.shared.ileDanJSON != aaa {
                    sleep(1) //opóźnienie = 1 sek.
                    aaa = Shared.shared.liczDania + 1 //ilość wczytanych dań - licznik w Network.swift
                }
                
                
                //print("lang =  \(Localize.currentLanguage())")
                AppDelegate.refresh_list_meal = true
                
                self.dismiss(animated: true, completion: nil)
            }
        
        }else {//jeżeli nie ma Internetu
            displayAlert()
        }
        
        
    }
   
    //zerowanie ustawień
    @IBAction func clearAllButton(_ sender: UIButton) {
        czasSlider.lowerValue = Double(memory1_0![0].a)!
        czasSlider.upperValue  = Double(memory1_0![0].b)!
        czasLabel.text = "L_OD".localized() + " \(memory1_0![0].a) " + "L_DO".localized() + " \(memory1_0![0].b)" + " min"
        wagaSlider.lowerValue = Double(memory1_0![0].c)!
        wagaSlider.upperValue  = Double(memory1_0![0].d)!
        wagaRangeLabel.text = "L_OD".localized() + " \(memory1_0![0].c) " + "L_DO".localized() + " \(memory1_0![0].d)" + " g/ml"
        kcalSlider.lowerValue = Double(memory1_0![0].e)!
        kcalSlider.upperValue  = Double(memory1_0![0].f)!
        kcalRangeLabel.text = "L_OD".localized() + " \(memory1_0![0].e) " + "L_DO".localized() + "  \(memory1_0![0].f)" + " kcal"
        cenaSlider.lowerValue = Double(memory2_0![0].a)!
        cenaSlider.upperValue  = Double(memory2_0![0].b)!
        cenaRangeLabel.text = "L_OD".localized() + " \(memory2_0![0].a) " + "L_DO".localized() + " \(memory2_0![0].b)" + " PLN"
        
        noLimitRadioButton.isSelected = true
    }
    
    @IBAction func clearCzasButton(_ sender: UIButton) {
        czasSlider.lowerValue = Double(memory1_0![0].a)!
        czasSlider.upperValue  = Double(memory1_0![0].b)!
        czasLabel.text = "L_OD".localized() + " \(memory1_0![0].a) " + "L_DO".localized() + " \(memory1_0![0].b)" + " min"
    }
    @IBAction func clearWagaButton(_ sender: UIButton) {
        wagaSlider.lowerValue = Double(memory1_0![0].c)!
        wagaSlider.upperValue  = Double(memory1_0![0].d)!
        wagaRangeLabel.text = "L_OD".localized() + " \(memory1_0![0].c) " + "L_DO".localized() + " \(memory1_0![0].d)" + " g/ml"
    }
    @IBAction func clearKcalButton(_ sender: UIButton) {
        kcalSlider.lowerValue = Double(memory1_0![0].e)!
        kcalSlider.upperValue  = Double(memory1_0![0].f)!
        kcalRangeLabel.text = "L_OD".localized() + " \(memory1_0![0].e) " + "L_DO".localized() + "  \(memory1_0![0].f)" + " kcal"
    }
    @IBAction func clearCenaButton(_ sender: UIButton) {
        cenaSlider.lowerValue = Double(memory2_0![0].a)!
        cenaSlider.upperValue  = Double(memory2_0![0].b)!
        cenaRangeLabel.text = "L_OD".localized() + " \(memory2_0![0].a) " + "L_DO".localized() + " \(memory2_0![0].b)" + " PLN"
    }
    
    
    
    
    @IBAction func exitButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //komunikat "Brak Internetu"
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
    }
    
}
