//
//  LoginController.swift
//  ZohoStay
//
//  Created by Pavan Gopal on 10/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import CoreData

class LoginController: UIViewController {

    @IBOutlet weak var emailIdTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isEnabled = false
        loginButton.backgroundColor = .red
        
        loginViewModel.isValidCredentials.bind = { [weak self] isvalid in
            guard let strongSelf = self else{return}
            
            strongSelf.loginButton.backgroundColor = isvalid ? .green : .red
            strongSelf.loginButton.isEnabled = isvalid
        }
        
    }

    @IBAction func emailIdTextDidChange(_ sender: UITextField) {
        loginViewModel.emailText.value = sender.text
        loginViewModel.validateCredentials()
    }
    
    @IBAction func passwordTextDidChange(_ sender: UITextField) {
        loginViewModel.passwordText.value = sender.text
        loginViewModel.validateCredentials()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        do{
            if let isValid = try loginViewModel.validateUser(){
                if isValid{
                    let alertController = UIAlertController(title: "Login Successful", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "Login Not Successful", message: "Please check your credentials", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        
        }catch{
            let alertController = UIAlertController(title: "Login Failed", message: "Please your credentials", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    
}
