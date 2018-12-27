//
//  LoginRequest.swift
//  MessagingApp
//
//  Created by Tushar on 27/12/18.
//  Copyright © 2018 Tushar. All rights reserved.
//

import Foundation

struct LoginRequest : Encodable {
    var email : String
    var password : String
}

extension Encodable
{
    var convertToDictionary : [String : Any]?
    {
        guard let data = try? JSONEncoder().encode(self) else {return nil}
        return(try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap {
            $0 as? [String : Any]
        }
        
    }
   
}
