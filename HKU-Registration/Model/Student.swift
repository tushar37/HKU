//
//  Student.swift
//  HKU-Registration
//
//  Created by Sachin Indulkar on 30/04/18.
//  Copyright © 2018 Sachin Indulkar. All rights reserved.
//

import UIKit

class Student: EVModelModified {
    var candidate_no    :String = ""
    var app_no          :String = ""
    var first_name      :String = ""
    var last_name       :String = ""
    var date_of_birth   :String = ""
    var registered      :Bool = false
    var group_no        :String = ""
    var pic             :String = ""
    var declaration     :String = ""
    var id              :String = ""
    var qrcode          :String = ""
    var color_code      :String = ""
    var hkid_no         :String = ""
    var image           : UIImage = UIImage()
    var signature       : UIImage = UIImage()
    
    func formatDOB ()-> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd "
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        
        if let date = dateFormatterGet.date(from: date_of_birth){
            return(dateFormatterPrint.string(from: date))
        }else {
            print("There was an error decoding the string")
            return ""
        }
    }
}
