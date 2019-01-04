//
//  AppManager.swift
//  MakeApp
//
//  Created by ananadmahajan on 7/12/17.
//  Copyright © 2017 ananadmahajan. All rights reserved.
//

import UIKit

//import FBSDKCoreKit
//import FBSDKLoginKit
//import GoogleSignIn
//import TwitterKit

var user_info_key = "user_info"
var language_key = "language"
var device_token_key = "device_token"

class AppManager: NSObject {
  
    class func getUserData() -> User {
        
        if let data = UserDefaults.standard.data(forKey:user_info_key),
            let objUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            return objUser
        }
        else {
            let objUser = User()
            return objUser
        }
    }
    
    class func saveUserData(objUser : User)
    {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: objUser)
        UserDefaults.standard.set(encodedData, forKey: user_info_key)
        
    }
    class func setUserLanguage (language : String)
    {
        UserDefaults.standard.set(language, forKey: language_key)
        
    }
    class func getUserLanguage () -> String
    {
        if UserDefaults.standard.string(forKey: language_key) != nil {
            return UserDefaults.standard.string(forKey: language_key)!
        }
        else
        {
            return ""
        }
    }
    
//    class  func isUserLogin() -> Bool
//    {
//
//
//        let objUser = self.getUserData()
//
//        if (objUser.userId != nil && !isEmpty(objUser.userId!)) {
//            return true
//        }
//
//        return false
//
//    }
    
   
    
    class func logout()
    {
        let objUser = User()
        
        self.saveUserData(objUser: objUser)
        
//        if(( FBSDKAccessToken.current()) != nil)
//       {
//        FBSDKLoginManager().logOut()
//        }
        
        //UserAPI().unregisterDevice(success: { (common_ob) in
        //}) { (error) in
        //}
    }
    
//    class func formatPriceWithCurrencyCode(price : Float , currency_code : String) -> String
//    {
//
//        // lblPrice.text = "\(NSString(format: "%.2g", objProductDetails.price) as String) " + AppManager.convertCurrencyCodeToSymbol(currency_code: objProductDetails.currency)
//
//        var strFormattedPrice = String()
//
//        let priceInteger = price.truncatingRemainder(dividingBy: 1)
//        if priceInteger != 0 {     // price contains some values after decimal like .57
//            strFormattedPrice = "\(NSString(format: "%.2f", price) as String) "
//        }else{
//            strFormattedPrice = "\(NSString(format: "%.0f", price) as String) "
//        }
//
//
//        if currency_code == "" {
//            let locale = NSLocale(localeIdentifier: CURRENCY_CODE)
//            let currencySymbol = locale.displayName(forKey: NSLocale.Key.currencySymbol, value: CURRENCY_CODE)! as String
//            strFormattedPrice =  strFormattedPrice + currencySymbol
//            return strFormattedPrice
//        }else{
//
//            if currency_code == "$" {
//                strFormattedPrice =  strFormattedPrice + currency_code
//                return strFormattedPrice
//            }
//            let locale = NSLocale(localeIdentifier: currency_code)
//            let currencySymbol = locale.displayName(forKey: NSLocale.Key.currencySymbol, value: currency_code)! as String
//            strFormattedPrice =  strFormattedPrice + currencySymbol
//            return strFormattedPrice
//        }
//
//
//    }
    
    
    
    
    class func convertTimeToFormattedType(strDate : String) -> String
    {
        //temprary code 
        
        let string = strDate
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    
    class func utc_stringToLocal_string(strDate:String) -> String {
        
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormator.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormator.date(from: strDate)
        dateFormator.timeZone = TimeZone.current
        dateFormator.dateFormat = "dd-MMM-yyyy HH:mm"
        
        return dateFormator.string(from: dt!)
    }
    
    
//    class func utc_TimeAgoString(strDate:String) -> String {
//
//        if strDate.characters.count > 0 {
//            let date = self.utc_dateFromString(strDate: strDate)
//            return self.timeAgo(date: date)
//        }
//        else{
//            return ""
//        }
//    }
    
    
    
    class func utc_dateFromString(strDate:String) -> Date {
        
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormator.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormator.date(from: strDate)
        return dt!
    }
    
    
//    class func timeAgo(date:Date) -> String {
//
//        let distanceBetweenDates: TimeInterval = date.timeIntervalSince(Date()) * (-1)
//        var distance = Int(floorf(Float(distanceBetweenDates)))
//
//        if distance <= 0 {
//            return SSLocalizedString("now", "")
//        }else if distance < SECONDS_IN_A_MINUTE {
//            //return "\(distance) " + SSLocalizedString("now", "")
//            return  SSLocalizedString("now", "")
//        }else if distance < SECONDS_IN_A_HOUR {
//            distance = distance / SECONDS_IN_A_MINUTE
//            return "\(distance) " + SSLocalizedString("minutes_ago", "")
//        }else if distance < SECONDS_IN_A_DAY {
//            distance = distance / SECONDS_IN_A_HOUR
//            return "\(distance) " + SSLocalizedString("hours_ago", "")
//        }else if distance < SECONDS_IN_A_MONTH_OF_30_DAYS {
//            distance = distance / SECONDS_IN_A_DAY
//            return "\(distance) "  + SSLocalizedString("days_ago", "")
//        }else if distance < SECONDS_IN_A_YEAR_OF_MONTH_OF_30_DAYS {
//            distance = distance / SECONDS_IN_A_MONTH_OF_30_DAYS
//            return "\(distance) "  + SSLocalizedString("months_ago", "")
//        }else {
//            distance = distance / SECONDS_IN_A_YEAR_OF_MONTH_OF_30_DAYS
//            return "\(distance) " + SSLocalizedString("years_ago", "")
//        }
//
//    }
    
    class func isEnteredFieldPhoneNumber(_ text : String) ->Bool
    {
        if (text as NSString).rangeOfCharacter(from:.letters).location != NSNotFound {
            return false
        }
        else
        {
            return true
        }
    }
    class func saveDeviceToken(device_token : String)
    {
        UserDefaults.standard.setValue(device_token, forKey: device_token_key);
    }
    class func getDeviceToken()->String {
        
        if((UserDefaults.standard.value(forKey: device_token_key)) != nil)
        {
            return (UserDefaults.standard.value(forKey: device_token_key) as! String)
        }
        else
        {
            return ""
        }
        
    }
    
    
    
    
    
    
    
    //    #pragma mark Alert view
    //    +(void)showHintView:(NSString *)text
    //    {
    //    [ToastMessage showSuccessMessage:text];
    //
    //    }
    //
    //    +(void)showHintErrorView:(NSError *)error
    //    {
    //    [ToastMessage showErrorMessageAppTitleWithMessage:[SSError getErrorMessage:error]];
    //    }
    //
    //    +(void)showHintErrorText:(NSString *)errorText
    //    {
    //    if (errorText.length==0 || errorText == nil)
    //    {
    //    [ToastMessage showErrorMessageAppTitleWithMessage:SSLocalizedString(@"error_message_generic", nil)];
    //    }else
    //    {
    //    [ToastMessage showErrorMessageAppTitleWithMessage:errorText];
    //    }
    //    }
    
    
    class func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    
    class func consistsOf15NumbersOnly(imei_number:String) -> Bool {
        let regex = "^\\d{15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: imei_number)
    }
    
    class func validateIMEI(imei_number:String) -> Bool {
        if !consistsOf15NumbersOnly(imei_number: imei_number) {
            return false
        }
        let length = imei_number.characters.count
        var sum: Int = 0
        for i in 0..<length - 1 {
            let value = Int((imei_number as NSString).substring(with: NSRange(location: i, length: 1))) ?? 0
            if i % 2 == 0 {
                sum += value
            }
            else {
                sum += value * 2 / 10 + value * 2 % 10
            }
        }
        let mod10: Int = sum % 10
        let checkDigit = Int((imei_number as NSString).substring(with: NSRange(location: length - 1, length: 1))) ?? 0
        return (mod10 + checkDigit) % 10 == 0
    }

//    class func getDistanceBeweenTwoLocations(first_location:CLLocation, second_location:CLLocation ) ->String
//    {
//        var meters: CLLocationDistance = first_location.distance(from: second_location)
//        var km = Int()
//        km = Int(meters/1000)
//        
//        let kmString = "\(km)"
//        return kmString
//    }
    
    class func SYSTEM_VERSION_LESS_THAN(version: NSString) -> Bool {
        return UIDevice.current.systemVersion.compare(version as String,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }

    
}







