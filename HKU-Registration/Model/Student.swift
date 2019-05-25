//
//  Student.swift
//  HKU-Registration
//
//  Created by Sachin Indulkar on 30/04/18.
//  Copyright © 2018 Sachin Indulkar. All rights reserved.
//

import UIKit
class Student: EVModelModified {
    var first_name      :String = ""
    var id              :String = ""
    var last_name       :String = ""
    var pic             :String = ""
    var uid             :String = ""
    var qrCode             :String = ""
    var station_no      :String = ""
    var order           :String = ""
    var registered      :Bool = false
    var image           : UIImage = UIImage()
}
