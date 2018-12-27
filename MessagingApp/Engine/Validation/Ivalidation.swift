//
//  Ivalidation.swift
//  MessagingApp
//
//  Created by Tushar on 27/12/18.
//  Copyright © 2018 Tushar. All rights reserved.
//

import Foundation


protocol Ivalidation {
    // Validate the passed dictionary
    func validate(input:[String:Any]) -> ValidationResult
}
