//
//  AppDelegate.swift
//  HKU-Registration
//
//  Created by Sachin Indulkar on 28/04/18.
//  Copyright © 2018 Sachin Indulkar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SystemConfiguration
import AlamofireNetworkActivityLogger
import Fabric
import Crashlytics

let appDel          = UIApplication.shared.delegate as! AppDelegate
let deviceID        = UIDevice.current.identifierForVendor!.uuidString
let appTitle        = "HKU-Registration"
let userData        = UserDefaults.init()
let SCREEN_SIZE     = UIScreen.main.bounds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
              Fabric.with([Crashlytics.self])
        self.configureLogIn()
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.initControllerBasedOnSession()
        return true
    }
    func initControllerBasedOnSession(){
        var vc = UIViewController()
        let objUser = AppManager.getUserData()
        if objUser.full_name.count > 0 || objUser.first_name.count > 0 {
            vc = ScannerView.init(nibName: "ScannerView", bundle: nil)
        }else{
            vc = LoginView.init(nibName: "LoginView", bundle: nil)
        }
        let nc = UINavigationController.init(rootViewController: vc)
        nc.isNavigationBarHidden = true
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
    }
    func configureLogIn()
    {
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func showAlertWith(view:UIViewController, title:String) {
        let alert = UIAlertController(title: appTitle,
                                      message: title,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.default,
                                      handler: {(alert: UIAlertAction!) in }))
        view.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Check Network Reachability
    func isConnectedToNetwork() -> Bool{
        guard let flags = getFlags() else
        {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func getFlags() -> SCNetworkReachabilityFlags?{
        guard let reachability = ipv4Reachability() ?? ipv6Reachability() else
        {
            return nil
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags)
        {
            return nil
        }
        return flags
    }
    
    func ipv6Reachability() -> SCNetworkReachability?{
        var zeroAddress = sockaddr_in6()
        zeroAddress.sin6_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin6_family = sa_family_t(AF_INET6)
        
        return withUnsafePointer(to: &zeroAddress,{
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    
    func ipv4Reachability() -> SCNetworkReachability?{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    
    func scaleAndRotateImage(image:UIImage, angle:CGFloat, flipVertical:CGFloat, flipHorizontal:CGFloat, targetSize:CGSize) -> UIImage? {
        let ciImage = CIImage(image: image)
        let filter = CIFilter(name: "CIAffineTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setDefaults()
        let newAngle = angle * CGFloat(-1)
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, CGFloat(newAngle), 0, 0, 1)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipVertical) * Double.pi), 0, 1, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipHorizontal) * Double.pi), 1, 0, 0)
        let affineTransform = CATransform3DGetAffineTransform(transform)
        filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: "inputTransform")
        let contex = CIContext(options: [kCIContextUseSoftwareRenderer:true])
        let outputImage = filter?.outputImage
        let cgImage = contex.createCGImage(outputImage!, from: (outputImage?.extent)!)
        let result = UIImage(cgImage: cgImage!)
        
        let originalSize = result.size
        let widthRatio = targetSize.width / originalSize.width
        let heightRatio = targetSize.height / originalSize.height
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: originalSize.width * ratio, height: originalSize.height * ratio)
        // preparing rect for new image size
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

