//
//  LoginViewModel.swift
//  ZohoStay
//
//  Created by Pavan Gopal on 10/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct LoginViewModel {
    
    var emailText: Dynamic<String> = Dynamic<String>("")
    var passwordText: Dynamic<String> = Dynamic<String>("")
    
    var isValidCredentials:Dynamic<Bool> = Dynamic<Bool>(false)
    
    func validateCredentials(){
        isValidCredentials.value = isValidEmailAddress() && isValidPassword()
    }
    
    func isValidEmailAddress() -> Bool {

        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"

        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)

            let results = regex.matches(in: emailText.value ?? "", range: NSRange(location: 0, length: emailText.value?.count ?? 0))

            if results.count == 0
            {
                returnValue = false
            }

        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }

        return  returnValue

    }
    
    func isValidPassword() -> Bool {
        
        
        return passwordText.value?.count ?? 0 >= 6
    }
    
    func validateUser() throws ->  Bool? {
        
        let request = NSFetchRequest<User>.init(entityName: "User")
        let emailPredicate = NSPredicate(format: "email == %@", emailText.value ?? "")
        let passwordPredicate = NSPredicate(format: "password == %@", passwordText.value ?? "")
        let compountPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [emailPredicate,passwordPredicate])
        
        request.predicate = compountPredicate
        
        var users:[User] = []
        
        do{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            users = try context.fetch(request)
            if let _ = users.first{
                return true
            }else{
                throw FetchError.NotFound
            }
            
        }catch let error{
            print("Fetching Failed")
            throw error
        }
        
    }
}
