//
//  LoginView.swift
//  HKU-Registration
//
//  Created by Sachin Indulkar on 28/04/18.
//  Copyright © 2018 Sachin Indulkar. All rights reserved.
//

import UIKit
import RNLoadingButton_Swift
class LoginView: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: RNLoadingButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLogin.activityIndicatorViewStyle = .white
    }
    
    //MARK :: UIButton action Methods
    @IBAction func loginBtnClick(_ sender: Any) {
        self.view.endEditing(true)
        if (txtUserName.text!.count == 0){
            appDel.showAlertWith(view: self, title: "Please enter username")
            return
        }
        if (txtPassword.text!.count == 0){
            appDel.showAlertWith(view: self, title: "Please enter password")
            return
        }
        
        let objUser = User ()
        objUser.username = self.txtUserName.text!
        objUser.password = self.txtPassword.text!
       
        if self.btnLogin.isLoading{
            return
        }
        self.btnLogin.isLoading = true
        RegisterationAPI().login(objUser: objUser, success: { (objUserResult) in
            self.btnLogin.isLoading = false
            if objUserResult.error == 1 { //Error
                appDel.showAlertWith(view: self, title: objUserResult.message!)
            }
            else{     //Success
                AppManager.saveUserData(objUser: objUserResult)
                let vc = ScannerView.init(nibName: "ScannerView", bundle: nil)
                vc.objUser = objUserResult
                if self.navigationController != nil {
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                let nc = UINavigationController.init(rootViewController: vc)
                nc.isNavigationBarHidden = true
                appDel.window?.rootViewController = nc
                appDel.window?.makeKeyAndVisible()
                self.txtUserName.text = ""
                self.txtPassword.text = ""
            }
        }) { (error) in
            appDel.showAlertWith(view: self, title: SSError.getErrorMessage(error))
            self.btnLogin.isLoading=false
        }
    }
}
