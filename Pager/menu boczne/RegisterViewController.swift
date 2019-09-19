//
//  RegisterViewController.swift
//  Pager
//
//  Created by darys on 23.04.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var hasloLabel: UILabel!
    @IBOutlet weak var haslo2Label: UILabel!
    
    @IBOutlet weak var loginTexField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!    
    @IBOutlet weak var repeatTextField: UITextField!
    
    @IBOutlet weak var powrotnyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "L_REJESTRACJA".localized()
        
        loginLabel.text = "L_LOGIN".localized()
        loginTexField.placeholder = "L_LOGIN".localized()
        
        emailLabel.text = "L_EMAIL".localized()
        emailTextField.placeholder = "L_EMAIL".localized()
        
        hasloLabel.text = "L_HASLO".localized()
        passwordTextField.placeholder = "L_HASLO".localized()
        
        haslo2Label.text = "L_HASLO_2".localized()
        repeatTextField.placeholder = "L_HASLO_2".localized()
        
        //własny button logowania
        let registerButton = UIButton()
        registerButton.backgroundColor = UIColor(red:200/255, green:0/255, blue:0/255, alpha:1.0)
        registerButton.frame = CGRect(x: 16, y: 382, width: view.frame.width - 32, height: 50)
        registerButton.layer.cornerRadius = 5
        registerButton.setTitle("L_REJESTRUJ".localized(), for: .normal)
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        registerButton.setTitleColor(.white , for: .normal)
        view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        //powrót do logowania
        powrotnyButton.setTitle("L_POWROT_LOGIN".localized(), for: .normal)
        powrotnyButton.setTitleColor(.white , for: .normal)
    }
    
    //usuwanie klawiatury z ekranu po naciśnięciu "Return" (działa przez delegata textField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // @IBAction func registrationButton(_ sender: Any) {
    @objc func   registerButtonTapped(){
        //sprawdzanie pustych pól w formularzu
        if (loginTexField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (repeatTextField.text?.isEmpty)!{
        
            displayMessage(userMessage: "L_WPROWADZ_DANE".localized())
            return
        }
        if ((passwordTextField.text?.count)! < 6) || ((passwordTextField.text?.count)! > 50){
            displayMessage(userMessage: "L_POPRAWNE_HASLO".localized())
            return
        }
        //walidacja hasła - czy oba hasła sa takie same
        if ((passwordTextField.text?.elementsEqual(repeatTextField.text!))! != true){
            displayMessage(userMessage: "L_SPRAWDZ_HASLO".localized())
            return
        }
        
        //utworzenie Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_register.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["login": loginTexField.text!,
                          "email": emailTextField.text!,
                          "password": passwordTextField.text!,] as [String: String]
        do{
          request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "L_BLAD_WYSLANIA_DANYCH".localized())
            return
        }
       
        
        let task = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
          
            if error != nil {
                self.displayMessage(userMessage: "L_BLAD_REJESTRACJI".localized())
                print("error======\(String(describing: error))")
                return
            }
            
            //konwertowanie danych odebranych z serwera
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                 //print ("json:====== \(String(describing: json!))")
                //print ("json:==\(String(describing: json!["error_email"]!))")
              
                let success = String(describing: json!["success"])
                print("ss=\(success)")
            
                if (success != "Optional(ok)"){
                    self.displayMessage(userMessage: "L_BLAD_ZLE_DANE".localized())
                    return
                }else{
                    self.displayMessageSuccess(userMessage: "L_REJESTRACJA_OK".localized())
                }
            } catch{
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "L_BLAD_REJESTRACJI".localized())
                print(error)
            }
        }
        
        task.resume()
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "L_ALERT".localized(), message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //code
                print ("OK")
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func displayMessageSuccess(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "L_SUKCES".localized(), message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action:UIAlertAction!) in
                //code
                //print ("OK")
                       DispatchQueue.main.async {
                          self.dismiss(animated: true, completion: nil)
                      }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
