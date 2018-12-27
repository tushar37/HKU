//
//  LoginManager.swift
//  MessagingApp
//
//  Created by Tushar on 27/12/18.
//  Copyright © 2018 Tushar. All rights reserved.
//

import Foundation

protocol ILoginManger {
    func checkLoginDetails(loginRequest:LoginRequest,completionHandler: @escaping(_ result : Bool, _ validationResult: ValidationResult) ->())
}



struct LoginManger : ILoginManger {
    var validation = loginDetailsValidator()
    func checkLoginDetails(loginRequest: LoginRequest, completionHandler: @escaping (Bool, ValidationResult) -> ()) {
        
        let validationResult = validation.validate(input: loginRequest.convertToDictionary!)
        if validationResult.success
        {
            
        }
        
    }
    
    
}
