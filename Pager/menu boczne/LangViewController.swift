//
//  LangViewController.swift
//  Pager
//
//  Created by darys on 06.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import DLRadioButton
import Localize_Swift

class LangViewController : UIViewController {

   //   @IBOutlet weak var zatwierdzButton: UIBarButtonItem!
//    @IBOutlet weak var wybierzLabel: UILabel!
    @IBOutlet weak var langView: UIView!
    
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var siec: Network?
    var memory1: [Memorydb]? = []         //filtry1 zapamiętane w bazie lokalnej
    var memory2: [Memorydb]? = []         //filtry2 zapamiętane w bazie lokalnej
    var rodzajSkladnika = [RodzajSk]()    //dane z JSONa - kategorie składników pobrane z www
    
    var activityIndicator = UIActivityIndicatorView()
    var reachability: Reachability?  //dostępność Internetu
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let titlelabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel1
        titlelabel1.text = "L_WYBIERZ_JEZYK".localized()
        titlelabel1.textAlignment = .center
        
//        zatwierdzButton.title = "L_ZATWIERDZ".localized()
        //navigationItem.title = "L_JEZYK".localized()
  //      wybierzLabel.text = "L_WYBIERZ_JEZYK".localized() + ":"
        
        // programmatically add buttons
        // first button
        //let frame = CGRect(x: self.view.frame.size.width / 2 - 131, y: 350, width: 262, height: 17);
        let frame = CGRect(x: 30, y: 25, width: 262, height: 25);
        let firstRadioButton = createRadioButton(frame: frame, title: "L_DOMYSLNY".localized(), index: 0);
        if Shared.shared.lang == "" { firstRadioButton.isSelected = true}
        
        //other buttons
        let languages = ["Polski", "Čeština", "Dansk", "Deutsch", "English", "Español", "Français", "Gaeilge", "Italino", "Magyar", "Norsk", "Português", "Slovenčina", "Suomi", "Svenska", "Türkçe", "Ελληνικά", "Pусский", "日本語", "中文"];
        //let colors = [UIColor.brown, UIColor.orange, UIColor.green, UIColor.blue, UIColor.purple];
        var i = 1;
        var otherButtons : [DLRadioButton] = [];
        for language in languages {
            let frame = CGRect(x: 30, y: 25 + 50 * CGFloat(i), width: 262, height: 25);
            let radioButton = createRadioButton(frame: frame, title: language, index: i);
            //if (i % 2 == 0) {
            //radioButton.isIconSquare = true;
            //}
            //if (i > 1) {
                 //put icon on the right side
               // radioButton.isIconOnRight = true;
                //radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right;
           // }
            otherButtons.append(radioButton);
            i += 1;
        }
        
        firstRadioButton.otherButtons = otherButtons;
        
        //----- wskaźnik aktywności-----------
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        //------------------------------------
        
    }
    
    // MARK: Helper
    
    private func createRadioButton(frame : CGRect, title : String, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 20);
        //if radioButton.titleLabel?.text == "Polski" { radioButton.isSelected = true}
        radioButton.tag = index
        //ustawienie czerwonej kropki na języku zapisanym w pamięci
        switch index {
            case 1: if Shared.shared.lang == "pl" { radioButton.isSelected = true}
            case 2: if Shared.shared.lang == "cs" { radioButton.isSelected = true}
            case 3: if Shared.shared.lang == "da" { radioButton.isSelected = true}
            case 4: if Shared.shared.lang == "de" { radioButton.isSelected = true}
            case 5: if Shared.shared.lang == "en" { radioButton.isSelected = true}
            case 6: if Shared.shared.lang == "es" { radioButton.isSelected = true}
            case 7: if Shared.shared.lang == "fr" { radioButton.isSelected = true}
            case 8: if Shared.shared.lang == "ga" { radioButton.isSelected = true}
            case 9: if Shared.shared.lang == "it" { radioButton.isSelected = true}
            case 10: if Shared.shared.lang == "hu" { radioButton.isSelected = true}
            case 11: if Shared.shared.lang == "nb" { radioButton.isSelected = true}
            case 12: if Shared.shared.lang == "pt" { radioButton.isSelected = true}
            case 13: if Shared.shared.lang == "sk" { radioButton.isSelected = true}
            case 14: if Shared.shared.lang == "fi" { radioButton.isSelected = true}
            case 15: if Shared.shared.lang == "sv" { radioButton.isSelected = true}
            case 16: if Shared.shared.lang == "tr" { radioButton.isSelected = true}
            case 17: if Shared.shared.lang == "el" { radioButton.isSelected = true}
            case 18: if Shared.shared.lang == "ru" { radioButton.isSelected = true}
            case 19: if Shared.shared.lang == "ja" { radioButton.isSelected = true}
            case 20: if Shared.shared.lang == "zh" { radioButton.isSelected = true}
        default: break //print("index języka poza zakresem ")
        }
        radioButton.marginWidth = 30
        radioButton.setTitle(title, for: []);
        radioButton.setTitleColor(UIColor.black, for: []);
        radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        radioButton.iconSize = 20
        
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(LangViewController.logSelectedButton), for: UIControlEvents.touchUpInside);
        self.langView.addSubview(radioButton);
        
        return radioButton;
    }
    
    //wybranie języka - radioButton'a
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        
        //sprawdzenie dostępu do Internetu
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            
            //----- wskaźnik aktywności-------
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            //---------------------------------
            
            //zapisanie wybranego języka do pamięci
            switch radioButton.selected()!.tag {
                case 0: Shared.shared.lang = ""
                case 1: Shared.shared.lang = "pl"
                case 2: Shared.shared.lang = "cs"
                case 3: Shared.shared.lang = "da"
                case 4: Shared.shared.lang = "de"
                case 5: Shared.shared.lang = "en"
                case 6: Shared.shared.lang = "es"
                case 7: Shared.shared.lang = "fr"
                case 8: Shared.shared.lang = "ga"
                case 9: Shared.shared.lang = "it"
                case 10: Shared.shared.lang = "hu"
                case 11: Shared.shared.lang = "nb"
                case 12: Shared.shared.lang = "pt"
                case 13: Shared.shared.lang = "sk"
                case 14: Shared.shared.lang = "fi"
                case 15: Shared.shared.lang = "sv"
                case 16: Shared.shared.lang = "tr"
                case 17: Shared.shared.lang = "el"
                case 18: Shared.shared.lang = "ru"
                case 19: Shared.shared.lang = "ja"
                case 20: Shared.shared.lang = "zh"
            default: Shared.shared.lang = ""
            }
        
             print("po Lang lang =  \(Shared.shared.lang!)")
             //print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
            
            //ustawienie języka aplikacji niezależnie od języka telefonu
            Localize.setCurrentLanguage("\(Shared.shared.lang!)")
            
            //update wybranego języka w bazie lokalnej -  do tabeli 'memory' rekord 'mem_app'
            _ = StephencelisDB.instance.updateMemory(mem: "mem_app", a: Shared.shared.lang, b: Shared.shared.lista, c: Shared.shared.ostrzezenia, d: "", e: "", f: "")
            
            //pobranie lokalizacji z tabeli 'memory->mem_lok' - pamięci ustawień z widoku ustawiania lokalizacji
            location = StephencelisDB.instance.getMemory(memo: "mem_lok")
            
            //== pobranie danych filtrów z tabeli 'memory'
            //mem_filtr1 (a:czasmin, b:czasmax, c:wagamin, d:wagamax, e:kcalmin, f:kcalma)
            memory1 = StephencelisDB.instance.getMemory(memo: "mem_filtr1")
            //mem_filtr2 (a:cenamin, b:cenamax, c:dla
            memory2 = StephencelisDB.instance.getMemory(memo: "mem_filtr2")
            
            //skasowanie wszystkich podkategorii z tabeli 'podkategorie'
            _ = StephencelisDB.instance.deletePodkategorieAll()
            //zerowanie tabeli 'dania' w bazie lokalnej
            _ = StephencelisDB.instance.deleteDaniaAll()
            
            //zerowanie tabeli 'rodzaje' w bazie lokalnej
            _ = StephencelisDB.instance.deleteRodzajeAll()
            
            siec = Network()
            //wczytanie wszystkich podkategorii
            siec!.importujPodkategorie()
            
            
            if Shared.shared.uz_id != nil {
                //pobranie dań z serwera dla wybranej restauracji lub miasta
                let res = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&dla=\(memory2![0].c)&czasmin=\(memory1![0].a)&czasmax=\(memory1![0].b)&cenamin=\(memory2![0].a)&cenamax=\(memory2![0].b)&wagamin=\(memory1![0].c)&wagamax=\(memory1![0].d)&kcalmin=\(memory1![0].e)&kcalmax=\(memory1![0].f)&lang=\(Localize.currentLanguage())")

                if res == 1{
                    //pobranie kategorii składników
                    self.downloadJSON_rodzaje{
                        
                        //zapisanie kategorii składników do bazy lokalnej 'Rodzaje'
                        for rodz in self.rodzajSkladnika {
                            _ = StephencelisDB.instance.addRodzaje(rdid: rodz.rd_id, rodzaj: rodz.rd_rodzaj, tot: rodz.total, dooceny: rodz.do_oceny, b01: rodz.o01, b02: rodz.o02, b03: rodz.o03, b04: rodz.o04, b05: rodz.o05, b06: rodz.o06, b07: rodz.o07, b08: rodz.o08, b09: rodz.o09, b10: rodz.o10, rdocena: rodz.rd_ocena)
                        }
                        
                        //ustawienie znacznika konieczności przeładowania listy dań
                        AppDelegate.refresh_list_meal = true
                        //zaznaczenie że menu boczne zostało zamknięte
                        AppDelegate.menu_bool = true

                        //opóźnienie żeby zdążyło przeładować dane
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                            
                            //Zwłoka do czasu pobrania wszystkich dań z internetu do bazy lokalnej
                            var aaa = 0
                            while Shared.shared.ileDanJSON != aaa {
                                sleep(1) //opóźnienie = 1 sek.
                                aaa = Shared.shared.liczDania + 1 //ilość wczytanych dań - licznik w Network.swift
                            }
                            
                            //----- wskaźnik aktywności-------
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            //---------------------------------
                            //przejście do listy dań
                            self.performSegue(withIdentifier: "unwindToParentFromLang", sender: self)
                        }
                    }
                }
            }else{
                //pobranie dań z serwera dla wybranej restauracji lub miasta
                 let res = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&dla=\(memory2![0].c)&czasmin=\(memory1![0].a)&czasmax=\(memory1![0].b)&cenamin=\(memory2![0].a)&cenamax=\(memory2![0].b)&wagamin=\(memory1![0].c)&wagamax=\(memory1![0].d)&kcalmin=\(memory1![0].e)&kcalmax=\(memory1![0].f)&lang=\(Localize.currentLanguage())")
            
                 if res == 1{
                    //ustawienie znacznika konieczności przeładowania listy dań
                    AppDelegate.refresh_list_meal = true
                    //zaznaczenie że menu boczne zostało zamknięte
                    AppDelegate.menu_bool = true
                    
                    //opóźnienie żeby zdążyło przeładować dane
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        
                        //Zwłoka do czasu pobrania wszystkich dań z internetu do bazy lokalnej
                        var aaa = 0
                        while Shared.shared.ileDanJSON != aaa {
                            sleep(1) //opóźnienie = 1 sek.
                            aaa = Shared.shared.liczDania + 1 //ilość wczytanych dań - licznik w Network.swift
                        }
                        
                        //----- wskaźnik aktywności-------
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        //---------------------------------
                        //przejście do listy dań
                        self.performSegue(withIdentifier: "unwindToParentFromLang", sender: self)
                    }
                }
            }
        }else {//jeżeli nie ma Internetu
            displayAlert()
        }
    }
 /*
    @IBAction func zatwierdzButton(_ sender: UIBarButtonItem) {
        
        //sprawdzenie dostępu do Internetu
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            //zwłoka na pobranie danych z Internetu
//            activityIndicator.startAnimating()
 //           Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in //UIApplication.shared.endIgnoringInteractionEvents()
                //print("lang =  \(Localize.currentLanguage())")
 //           }
                //ustawienie znacznika konieczności przeładowania listy dań
                AppDelegate.refresh_list_meal = true
                //zaznaczenie że menu boczne zostało zamknięte
                AppDelegate.menu_bool = true
                
                //przejście do listy dań
                self.performSegue(withIdentifier: "unwindToParentFromLang", sender: self)
            
        }else {//jeżeli nie ma Internetu
            displayAlert()
        }
    }
 */
 //   @IBAction func exitButton(_ sender: UIBarButtonItem) {
 //       dismiss(animated: true, completion: nil)
  //  }

    //komunikat "Brak Internetu"
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
    }
    
    //=========================================================
    //funkcja pobierająca JSONa ze szczegółami restauracji (id dania z tabeli 'memory')
    //=========================================================
    func downloadJSON_rodzaje(completed: @escaping () -> ()) {
        let url = URL(string: "https://cobytu.com/cbt.php?d=ios_rodzaje_do&uz_id=\(Shared.shared.uz_id!)&lang=\(Localize.currentLanguage())")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    self.rodzajSkladnika = try JSONDecoder().decode([RodzajSk].self, from: data!)
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

