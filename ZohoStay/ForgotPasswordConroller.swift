//
//  ForgotPasswordConroller.swift
//  ZohoStay
//
//  Created by Pavan Gopal on 10/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import CoreData

class ForgotPasswordConroller: UIViewController {

    @IBOutlet weak var ForgotPasswordButton: UIButton!
    var emailId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func retrieveUser(emailId:String?) throws ->  User? {
        guard let emailIdUnwrpped = emailId else {return nil}
        
        let request = NSFetchRequest<User>.init(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@", emailIdUnwrpped)

        var users:[User] = []
        
        do{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            users = try context.fetch(request)
            if let user = users.first{
             return user
            }else{
                throw FetchError.NotFound
            }
            
        }catch let error{
            print("Fetching Failed")
            throw error
        }
        
    }
    

    @IBAction func forgotButtonPressed(_ sender: UIButton) {
        do{
            let user = try retrieveUser(emailId: emailId)
            
            let alertController = UIAlertController(title: "Password Found", message: "Password: \(user?.password ?? "")", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }catch let error{
            
            let alertController = UIAlertController(title: "Password Not Found", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
       
    }
    
    @IBAction func emailTextFieldTextChange(_ sender: UITextField) {
        emailId = sender.text
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

enum FetchError:Error{
    case NotFound
}
