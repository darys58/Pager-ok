//
//  QRKodStolikaVC.swift
//  Pager
//
//  Created by darys on 08.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import Localize_Swift

class QRKodStolikaVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    
    var siec: Network?
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    
    var video = AVCaptureVideoPreviewLayer()
    var qrCodeFrameView:UIView?
    // Creating session
    let session = AVCaptureSession()
    
    var activityIndicator = UIActivityIndicatorView()
     var reachability: Reachability?  //dostępność Internetu
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "L_SKANUJ_KODU_STOL".localized()
        messageLabel.text = "L_BRAK_QR".localized()
        
        //Zdefiniuj urządzenie przechwytujące
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
  
        //Przenieś etykietę wiadomości na wierzch
        view.bringSubview(toFront: messageLabel)
        
        //Zainicjuj QR Code Frame, aby podświetlić kod QR
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
        
        //Sprawdź, czy tablica metadataObjects nie jest pusta i zawiera co najmniej jeden obiekt.
        if  metadataObjects.count == 0 { //metadataObjects == nil ||
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "L_BRAK_QR".localized() //Brak kodu QR/No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Tutaj używamy metody filtrowania, aby sprawdzić, czy obsługiwany jest typ metadataObj
        // Zamiast kodowania twardego AVMetadataObjectTypeQRCode, sprawdzamy,
        // czy typ można znaleźć w tablicy obsługiwanych kodów kreskowych
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // Jeśli znalezione metadane są równe metadanym kodu QR, zaktualizuj tekst etykiety statusu i ustaw granice
            let barCodeObject = video.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil { //jeżeli odczytano prawidłowy link z QR kodu
                let str = metadataObj.stringValue

                if (metadataObj.stringValue?.contains("kod="))!{ //to jeżeli link zawiera "rest="
                    var index = str?.index((str?.endIndex)!, offsetBy:-1) //to tylko deklaracja zmiennej 'index'
                    var i = 0
                    var a = "" //temp
                    var b = "" //id restauracji pobrana z linku zdekodowanego QR kodu
                    var c = "" //kod stolila w formacie ab-123
                    repeat{
                        b = a + b //odtworzenie id restauracji z linku np. z  rest=123 (musi być na końcu linku)
                        i += 1
                        index = str?.index((str?.endIndex)!, offsetBy:-i)
                        a = String(str![index!]) //
                    }while a != "=" //koniec jeżeli dojdzie do znaku "="

                    //pobranie lokalizacji z tabeli 'memory' - pamięci ustawień z widoku ustawiania lokalizacji
                    location = StephencelisDB.instance.getMemory(memo: "mem_lok")
                    
                    if b == location![0].e { //jeżeli jest to stolik w wybranej restauracji
                    
                        i = i + 6 //przeskoczenie w linku &rest= by dojść do kodu stolika
                        
                        //odczytanie i utworzenie kodu stolika
                        index = str?.index((str?.endIndex)!, offsetBy:-i)
                        a = String(str![index!]) //xx-xx0
                        c = a + c
                        i += 1
                        
                        index = str?.index((str?.endIndex)!, offsetBy:-i)
                        a = String(str![index!]) //xx-x0x
                        c = a + c
                        i += 1
                        
                        index = str?.index((str?.endIndex)!, offsetBy:-i)
                        a = String(str![index!]) //xx-0xx
                        c = a + c
                        i += 1
                        
                        a = "-"  //wstawienie znaku "-"
                        c = a + c
                        
                        index = str?.index((str?.endIndex)!, offsetBy:-i)
                        a = String(str![index!]) //x0-xxx
                        c = a + c
                        i += 1
                        
                        index = str?.index((str?.endIndex)!, offsetBy:-i)
                        a = String(str![index!]) //0x-xxx
                        c = a + c
                      
        //print ("kod=\(c)")
                        
                        //kod stolika zapisany w pamięci
                        Shared.shared.kod_stolika = c
                        messageLabel.text = c

                    
                        session.stopRunning() //zatrzymanie skanowania QR kodów
                        //AudioServicesPlayAlertSound(1000) //sygnał dźwiękowy
                        AudioServicesPlaySystemSound(1255) //sygnał dźwiękowy
                       
                        dismiss(animated: true, completion: nil)
                    }else{
                        Shared.shared.kod_stolika = "?"
                        session.stopRunning() //zatrzymanie skanowania QR kodów
                        AudioServicesPlaySystemSound(1257) //sygnał dźwiękowy
                        dismiss(animated: true, completion: nil)
                      
                        
                    }
                }else{
                    messageLabel.text = "L_TO_NIE_KOD".localized()
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
    
    //komunikat "Brak Internetu"
    func displayAlertStolik() {
        let alertViev = UIAlertController (title: "L_BLAD_WYBORU".localized(), message: "L_W_RESTA".localized() + location![0].f + "L_NIE_MA_STOLIKA".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
        
    }
    
}
