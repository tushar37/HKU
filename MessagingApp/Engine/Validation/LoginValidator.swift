//
//  LoginValidator.swift
//  MessagingApp
//
//  Created by Tushar on 27/12/18.
//  Copyright © 2018 Tushar. All rights reserved.
//

import Foundation



struct loginDetailsValidator : Ivalidation {
    func validate(input: [String : Any]) -> ValidationResult {
        assert(input.count != 0)
        var validation = ValidationResult()
        
        if (input["name"] as! String).isEmpty == true
        {
            validation.error = ["error":"Name can not be empty"]
        }
        return validation
        
    }
    
}
