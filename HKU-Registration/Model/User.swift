//
//  User.swift
//  HKU-Registration
//
//  Created by Sachin Indulkar on 30/04/18.
//  Copyright © 2018 Sachin Indulkar. All rights reserved.
//

import UIKit

class User: EVModelModified {

    var username    :String = ""
    var password    :String = ""
    var device_id   :String = deviceID
    var token_id    :String = "TRUE"
    var first_name  :String = ""
    var last_name   :String = ""
    var pic         :String = ""
    var full_name   :String = ""
    var event_name  :String = ""
    var error       :Int = 0

}

class NDA: EVModelModified {
    
    var error    :Int = 0
    var student_nda    :String = ""

}
