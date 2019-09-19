//
//  QRLocationVC.swift
//  Pager
//
//  Created by darys on 08.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import Localize_Swift

class QRLocationVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    
    var siec: Network?
    var memory1: [Memorydb]? = []         //filtry1 zapamiętane w bazie lokalnej
    var memory2: [Memorydb]? = []         //filtry2 zapamiętane w bazie lokalnej
    
    var video = AVCaptureVideoPreviewLayer()
    var qrCodeFrameView:UIView?
    // Creating session
    let session = AVCaptureSession()
    
    var activityIndicator = UIActivityIndicatorView()
     var reachability: Reachability?  //dostępność Internetu
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "L_SKANOWANIE_KODU".localized()
        messageLabel.text = "L_BRAK_QR".localized()
        
        //Define capture device
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)

        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }catch{
            print("Error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        //self.view.bringSubview(toFront: squareImage)
        
        session.startRunning()
  
        // Move the message label to the top view
        view.bringSubview(toFront: messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 5
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        
        //wskaźnik aktywności
        activityIndicator.center = CGPoint.init(x: self.view.frame.size.width/2, y: 200)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(activityIndicator)
    }

    //komunikat na ekranie
 /*   func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: {(nil) in UIPasteboard.general.string = object.stringValue
                        
                    }))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
 */

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if  metadataObjects.count == 0 { //metadataObjects == nil ||
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "L_BRAK_QR".localized() //Brak kodu QR/No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        //if supportedBarCodes.contains(metadataObj.type) {
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = video.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil { //jeżeli odczytano prawidłowy link z QR kodu
                let str = metadataObj.stringValue
                    //messageLabel.text = metadataObj.stringValue
                if (metadataObj.stringValue?.contains("rest="))!{ //to jeżeli link zawiera "rest="
                    var index = str?.index((str?.endIndex)!, offsetBy:-1) //to tylko deklaracja zmiennej 'index'
                    var i = 0
                    var a = "" //temp
                    var b = "" //id restauracji pobrana z linku zdekodowanego QR kodu
                    repeat{
                        b = a + b //odtworzenie id restauracji z linku np. z  rest=123 (musi być na końcu linku)
                        i += 1
                        index = str?.index((str?.endIndex)!, offsetBy:-i)
                        a = String(str![index!]) //
                    }while a != "=" //koniec jeżeli dojdzie do znaku "="
                
                    let czyJest = StephencelisDB.instance.czyRestauracja(rest: b)
                    //messageLabel.text = metadataObj.stringValue
                    
                    //jeżeli jest taka restauracja w bazie to wykonanie zmiany lokalizacji w appce
                    if czyJest == 1 {
                        //pobranie danych nowej restauracji
                        let restauracja = StephencelisDB.instance.getRestaurantWithId(res: b)
                        //print("test = \(restauracja[0].reid)")
                        session.stopRunning() //zatrzymanie skanowania QR kodów
                        //AudioServicesPlayAlertSound(1000) //sygnał dźwiękowy
                        AudioServicesPlaySystemSound(1255) //sygnał dźwiękowy
                        
                        messageLabel.text = restauracja[0].nazwa + ", " + restauracja[0].miasto + ", " + restauracja[0].adres
                        
                        //sprawdzenie dostępu do Internetu
                        self.reachability = Reachability.init()
                        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
                            let rest = restauracja[0].reid
                            let mia_id = restauracja[0].mia_id
                            let woj_id = restauracja[0].woj_id
                        
                            //update lokalizacji w bazie lokalnej - nowa lokalizacja zapisana do tabeli 'memory' rekord 'mem_lok'
                            _ = StephencelisDB.instance.updateMemory(mem:"mem_lok", a: restauracja[0].woj_id, b: restauracja[0].woj, c: restauracja[0].mia_id, d: restauracja[0].miasto, e: restauracja[0].reid, f: restauracja[0].nazwa)
                            
                            
                            //== pobranie danych filtrów z tabeli 'memory'
                            //mem_filtr1 (a:czasmin, b:czasmax, c:wagamin, d:wagamax, e:kcalmin, f:kcalma)
                            memory1 = StephencelisDB.instance.getMemory(memo: "mem_filtr1")
                            //mem_filtr2 (a:cenamin, b:cenamax, c:dla
                            memory2 = StephencelisDB.instance.getMemory(memo: "mem_filtr2")
                            
                            _ = StephencelisDB.instance.deleteDaniaAll()   //zerowanie tabeli 'dania' w bazie lokalnej
                            
                            //pobranie dań z serwera dla wybranej restauracji
                            siec = Network()
                            _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(woj_id)&mia_id=\(mia_id)&rest=\(rest)&dla=\(memory2![0].c)&czasmin=\(memory1![0].a)&czasmax=\(memory1![0].b)&cenamin=\(memory2![0].a)&cenamax=\(memory2![0].b)&wagamin=\(memory1![0].c)&wagamax=\(memory1![0].d)&kcalmin=\(memory1![0].e)&kcalmax=\(memory1![0].f)&lang=\(Localize.currentLanguage())")
                            
                            //zwłoka na pobranie danych z Internetu
                            activityIndicator.startAnimating()
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                                
                                //Zwłoka do czasu pobrania wszystkich dań z internetu do bazy lokalnej
                                var aaa = 0
                                while Shared.shared.ileDanJSON != aaa {
                                    sleep(1) //opóźnienie = 1 sek.
                                    aaa = Shared.shared.liczDania + 1 //ilość wczytanych dań - licznik w Network.swift
                                }
                                
                                UIApplication.shared.endIgnoringInteractionEvents()
                                //print("lang =  \(Localize.currentLanguage())")
                                
                                AppDelegate.refresh_list_meal = true
                                Shared.shared.strefa = 0 //domyślne ustawienie strefy dostawy(również w Location i AppDelegate)
                                Shared.shared.platnosc = 0 //0 - brak danych - domyślne ustawienie sposobu płatności za dostawę
                                //uruchomienie przejścia o ID "unwindToParent" ???????
                                self.performSegue(withIdentifier: "segueToParent", sender: self)
                            }
                            
                        }else{//jeżeli nie ma Internetu
                            displayAlert()
                        }
                    }else{
                        messageLabel.text = "L_NIE_MA_LOKALU".localized()
                    }
                }else{
                    messageLabel.text = "L_TO_NIE_LOKAL".localized()
                }
            }
        }
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
