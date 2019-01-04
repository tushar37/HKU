//
//  DetailWrapper.swift
//  HKU-Registration
//
//  Created by Sachin Indulkar on 30/04/18.
//  Copyright © 2018 Sachin Indulkar. All rights reserved.
//

import UIKit

class DetailWrapper: EVModelModified {

    var student     : Student?
    var circuit     : [Circuit]? = []
    var error       : Int = 0
    
    
    func getCircut() -> NSAttributedString {
       
        let activeAttributes    = [NSAttributedStringKey.foregroundColor : UIColor.black];
        let inActiveAttributes  = [NSAttributedStringKey.foregroundColor : UIColor.green];
        let atributtedString    = NSMutableAttributedString.init()
        
        for  objCircute:Circuit in circuit! {
            if atributtedString.length > 0 {
                if  objCircute.status {
                    let atrStr = NSAttributedString(string: "-\(objCircute.station_no)", attributes: inActiveAttributes)
                    atributtedString.append(atrStr)
                }
                else {
                    let atrStr = NSAttributedString(string: "-\(objCircute.station_no)", attributes: activeAttributes)
                    atributtedString.append(atrStr)
                }
            }else{
                if  objCircute.status {
                    let atrStr = NSAttributedString(string: "\(objCircute.station_no)", attributes: inActiveAttributes)
                    atributtedString.append(atrStr)
                }else {
                    let atrStr = NSAttributedString(string: "\(objCircute.station_no)", attributes: activeAttributes)
                    atributtedString.append(atrStr)
                }
            }
            
        }
        return atributtedString
    }
}
