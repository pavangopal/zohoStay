//
//  RegistrationController.swift
//  ZohoStay
//
//  Created by Pavan Gopal on 10/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import CoreData

class RegistrationController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registerButton: UIButton!
    
    var user:User?
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.user = User(context: context)
        
        loginViewModel.isValidCredentials.bind = { [weak self] isvalid in
            guard let strongSelf = self else{return}
            strongSelf.registerButton.isEnabled = isvalid
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if let userUnwrapped = user {
            context.insert(userUnwrapped)
            do {
                try context.save()
                let alertController = UIAlertController(title: "Registration Successful", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true) {
                    self.dismiss(animated: true, completion: nil)
                }
                
            } catch let error{
                print("Failed saving with error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Failed to register user", message: "This user is already present, please login to continue", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func phoneNumber(_ sender: UITextField) {
        user?.phoneNumber = sender.text
    }
    
    @IBAction func emailTextChange(_ sender: UITextField) {
        user?.email = sender.text
        loginViewModel.emailText.value = sender.text
        loginViewModel.validateCredentials()
    }
    
    @IBAction func nametextChange(_ sender: UITextField) {
        user?.name = sender.text
    }
    
    @IBAction func passwordTextChange(_ sender: UITextField) {
        user?.password = sender.text
        loginViewModel.passwordText.value = sender.text
        loginViewModel.validateCredentials()
    }
    
    func retrieveUsers(){
        let request = NSFetchRequest<User>.init(entityName: "User")
        var users:[User] = []
        
        do{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            users = try context.fetch(request)
            print(users)
        }catch{
            print("Fetching Failed")
        }
    }
    
    
}
