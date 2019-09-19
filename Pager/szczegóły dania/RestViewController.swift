//
//  RestViewController.swift
//  Pager
//
//  Created by darys on 23.01.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import MessageUI
import CoreTelephony

class RestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate{

    @IBOutlet var restTableView: UITableView!
    
    var meal_resta = [MealResta]()            //dane z JSONa - szczegóły restauracji pobrane z www
   
    
    override func viewDidLoad() { //funkcja wykonuje tylko raz przy pierwszym wejściu do rest
        super.viewDidLoad()
        
        restTableView.estimatedRowHeight = 175
        restTableView.rowHeight = UITableViewAutomaticDimension
    
        meal_resta = Shared.shared.restauracje  //pobranie danych wszystkich restauracji z pamięci
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {//funkcja wykonuje się przy każdym wejściu
        //potrzebne dla wersji dania
        //pobranie danych bo może była zmiana wersji i trzeba wczytać dane nowego dania
        meal_resta = Shared.shared.restauracje  //pobranie danych wszystkich restauracji z pamięci
        //przeładowanie danych w tabeli
        self.restTableView.reloadData()
    }
    
    
/*
     
     @IBAction func sendEmail(_ sender: Any) {
           let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            showMailError()
        }
    }
     
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["darys@konet.pl"])
        mailComposerVC.setSubject("CoByTu mobile")
        mailComposerVC.setMessageBody("Message", isHTML: false)
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title:"Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated:  true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
  */
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.meal_resta.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestTableViewCell", for: indexPath) as! RestTableViewCell
        
        let formatter1 = NumberFormatter() //deklaracja obiektu formatera
        formatter1.numberStyle = .decimal //ustawienie stylu formatera jako liczby
        formatter1.minimumFractionDigits = 2 //ilość miejsc po przecinku
        
        cell.nazwaLabel.text = self.meal_resta[indexPath.row].re_nazwa
        //cell.cenaLabel.text = self.meal_resta[indexPath.row].cena
 /* cena nie wyświetlana bo jest to tylko cena podstawowa i nie uwzględnia dodatków wariant i dod
        //formatowanie i wyświetlanie ceny
        let numCena = formatter1.string(from: NSNumber(value: Float(self.meal_resta[indexPath.row].cena)!))
        cell.cenaLabel.text = "\(numCena! ) " + "L_PLN".localized()
  */
        cell.adresLabel.text = " " + self.meal_resta[indexPath.row].re_miasto + ", " + self.meal_resta[indexPath.row].re_adres
        //cell.otwarteText.text = self.meal_resta[indexPath.row].re_otwarte

/*      //aktualny dzień tygodnia
        let date = Date()
        let calender = Calendar.current
        print ("dzien=")
        print(calender.component(.weekday, from: date))
 */
        //godziny otwarcia
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(self.meal_resta[indexPath.row].re_otwarte_a)
            .bold(self.meal_resta[indexPath.row].re_otwarte_b)
            .normal(self.meal_resta[indexPath.row].re_otwarte_c)
        cell.otwarteText.attributedText = formattedString
        
        cell.phoneButton.tag = indexPath.row
        cell.phoneButton.addTarget(self, action: #selector(self.callPhone), for: .touchUpInside)
        cell.mailButton.tag = indexPath.row
        cell.mailButton.addTarget(self, action: #selector(self.sendEmail), for: .touchUpInside)
        cell.wwwButton.tag = indexPath.row
        cell.wwwButton.addTarget(self, action: #selector(self.wwwLink), for: .touchUpInside)
        cell.gpsButton.tag = indexPath.row
        cell.gpsButton.addTarget(self, action: #selector(self.mapPoint), for: .touchUpInside)
        cell.facilButton.tag = indexPath.row
        cell.facilButton.addTarget(self, action: #selector(self.facilities), for: .touchUpInside)
        return cell
    }
    
    //func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
     //   return 200
    //}
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "L_DANIE_DOSTEPNE".localized() + ":"
    }
   // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //     return 180
   // }

    //===============================
    //telefon do restauracji
    //===============================
    @IBAction func callPhone(_ sender: UIButton) {
        //UIApplication.shared.open(NSURL(string:"tel://\(self.meal_resta[sender.tag].re_tel1)")! as URL)
        //sprawdzenie czy telefon ma katrę SIM
        var availbleSIM: Bool {
            return CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode != nil
        }
        if availbleSIM {
            let trimmedString = self.meal_resta[sender.tag].re_tel1.replacingOccurrences(of: " ", with: "")
            //print("tel://\(trimmedString)")
            //print("tel://\(self.meal_resta[0].re_tel1)")
            //UIApplication.shared.open(NSURL(string:"tel://\(self.meal_resta[sender.tag].re_tel1)")! as URL)
            let url: NSURL = URL(string: "tel://\(trimmedString)")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }else{
            displayAlertSIM()
        }
    }
    //================================
    //Wysyłanie meila do restauracji
    //================================
    @IBAction func sendEmail(_ sender: UIButton) {
        UIApplication.shared.open(NSURL(string:"mailto:\(self.meal_resta[sender.tag].re_email)")! as URL)
    }

    //==================================
    //link do strony www
    //==================================
    @IBAction func wwwLink(_ sender: UIButton) {
        UIApplication.shared.open(NSURL(string:"http://\(self.meal_resta[sender.tag].re_www)")! as URL)
    }
    
    //==================================
    //lokalizacja na mapie
    //==================================
    @IBAction func mapPoint(_ sender: UIButton) {
        let string = "http://maps.google.com/maps?daddr=\(self.meal_resta[sender.tag].re_gps)"
        let string_formated = string.replacingOccurrences(of: " ", with: "") //usuwanie spacji
        UIApplication.shared.open(NSURL(string: string_formated)! as URL)
    }
    
    //==================================
    //udogodnienia w restauracji - wywołanie okna popup
    //==================================
    @IBAction func facilities(_ sender: UIButton) {
        Shared.shared.facilities_rest_index = sender.tag //zapamiętanie indexu restauracji po kliknięciu przycisku
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpRest") as! RestPopViewController
        self.addChildViewController(popupVC)
        popupVC.view.frame = self.view.frame
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
    }

    //komunikat "Brak karty SIM"
    func displayAlertSIM() {
        let alertViev = UIAlertController (title: "L_BRAK_SIM".localized(), message: "L_TELEFON_BEZ_SIM".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Bold", size: 15)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Regular", size: 14 )!]
        let normal = NSAttributedString(string: text, attributes: attrs)
       
        append(normal)
        
        return self
    }
}
