//
//  Utility.swift
//  MakeApp
//
//  Created by ananadmahajan on 6/29/17.
//  Copyright © 2017 ananadmahajan. All rights reserved.
//

import UIKit

 func setLeftBarButtonWith(_ image: UIImage, forNavigatinItem navigatinItem: UINavigationItem, forTarget target: Any, action:  Selector?) {
    var imageCross: UIImage? = image
    imageCross = imageCross?.withRenderingMode(.alwaysOriginal)
    let button = UIBarButtonItem(image: imageCross, style: .plain, target: target, action: action)
    navigatinItem.leftBarButtonItem = button
}

 func setRightBarButtonWith(_ image: UIImage, forNavigatinItem navigatinItem: UINavigationItem, forTarget target: Any, action: Selector?) {
    var imageCross: UIImage? = image
    imageCross = imageCross?.withRenderingMode(.alwaysOriginal)
    let button = UIBarButtonItem(image: imageCross, style: .plain, target: target, action: action)
    navigatinItem.rightBarButtonItem = button
}

 func setRightBarButtonWithText(_ text: String, forNavigatinItem navigatinItem: UINavigationItem, forTarget target: Any, action: Selector?) {
    let button = UIBarButtonItem(title: text, style: .plain, target: target, action: action)
    navigatinItem.rightBarButtonItem = button
}

 func setRoundedImageView(_ imageview: UIImageView) {
    imageview.layer.cornerRadius = imageview.frame.size.height / 2
    imageview.layer.masksToBounds = true
}
func isEmpty(_ str: String) -> Bool
{
    let whitespace = CharacterSet.whitespacesAndNewlines
    if (str is String) {
        if (str is NSNull) || (str == "") || (str == "(null)") || str == nil || (str == "<null>") || (str == "null") || (str.trimmingCharacters(in: whitespace)).characters.count == 0 {
            return true
        }
    }
    else if (str is NSNull) {
        return true
    }
    else if str == nil {
        return true
    }
    
    return false
}

//func applyGlobalInterfaceAppearance() {
//    
//    let backArrowImage  = UIImage(named: "back") // set your back button image here
//    let renderedImage = backArrowImage?.withRenderingMode(.alwaysOriginal).withAlignmentRectInsets(UIEdgeInsetsMake(-100, 00, 20, 0))
//    UINavigationBar.appearance().backIndicatorImage = renderedImage
//    UINavigationBar.appearance().backIndicatorTransitionMaskImage = renderedImage
//    
//    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: FONT_AVENIR_MEDIUM_8 ]
//   
//    UINavigationBar.appearance().tintColor = UIColor.white
//    UINavigationBar.appearance().barTintColor = UICOLOR_NAVIGATION_BG
//    UINavigationBar.appearance().backgroundColor = UICOLOR_NAVIGATION_BG
// //   var system_version = UIDevice.current.systemVersion
//    
//    let barAppearace = UIBarButtonItem.appearance()
//    barAppearace.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
//}
//
//
//
//
// func setCornerRadius(_ view: UIView, radius: CGFloat) {
//    view.layer.cornerRadius = radius
//    view.layer.masksToBounds = true
//}
//
// func setBorderFor(_ yourView: UIView, withWidth borderwidth: CGFloat, borderColor color: UIColor) {
//    yourView.layer.borderWidth = borderwidth
//    yourView.layer.borderColor = color.cgColor
//}
//
//
// func isIPhone4() -> Bool {
//    if SCREEN_SIZE.height == 480 {
//        return true
//    }
//    return false
//}
//
// func isIPhone5() -> Bool {
//    if SCREEN_SIZE.height == 568 {
//        return true
//    }
//    return false
//}
//
// func isIPhone6OrIPhone7() -> Bool {
//    if SCREEN_SIZE.height == 667 {
//        return true
//    }
//    return false
//}
//
// func isIPhone6PlusOrIPhone7Plus() -> Bool {
//    if SCREEN_SIZE.height == 736 {
//        return true
//    }
//    return false
//}
//
// func setShadowTo(_ your_view: UIView) {
//    let shadowLayer: CALayer? = your_view.layer
//    shadowLayer?.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0))
//    shadowLayer?.shadowColor = UICOLOR_LABEL_DARK_COLOR.cgColor
//    shadowLayer?.shadowRadius = 2.0
//    shadowLayer?.shadowOpacity = 1.0
//    shadowLayer?.cornerRadius = 3
//}
//
//func isValidEmail(email:String) -> Bool {
//    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
//    return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.characters.count)) != nil
//}
//func validateAlphabets(_ alpha: String) -> Bool {
//    let trimmedString = alpha.trimmingCharacters(in: .whitespacesAndNewlines)
//
//    let abnRegex: String = "[A-Za-z]+"
//    // check for one or more occurrence of string you can also use * instead + for ignoring null value
//    let abnTest = NSPredicate(format: "SELF MATCHES %@", abnRegex)
//    let isValid: Bool = abnTest.evaluate(with: trimmedString)
//    return isValid
//}
//
//func isValidPhoneNumer( _ phone_number:String) -> Bool
//{
//    if phone_number.characters.count < 10 ||  phone_number.characters.count > 10  {
//        
//        return false
//    }
//    return true
//}
//func formattedDateForBadges ( _ input_date : String) -> String
//{
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//    let yourDate: Date? = dateFormatter.date(from: input_date)
//    dateFormatter.dateFormat = "dd-MMM-yyyy, hh:mm a"
//    return (dateFormatter.string(from: yourDate!))
//}
