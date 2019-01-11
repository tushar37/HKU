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
    
    let nsud = UserDefaults.standard
    @IBOutlet weak var logoImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nsud.set("Nursing", forKey: "SelectedOption")
        self.btnLogin.activityIndicatorViewStyle = .white
    }
    @IBOutlet weak var tittleLbl: UILabel!
    @IBOutlet weak var logoImgWidth: NSLayoutConstraint!
    
    @IBOutlet weak var logoImgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dropDownBtn: UIButton!
    
    func presentView(imageName:String,logoWidth:CGFloat,tittle:String,typeOfString:String)
    {
        self.nsud.set(typeOfString, forKey: "SelectedOption")
        self.logoImgView.image = UIImage(named: imageName)
        self.logoImgWidth.constant = logoWidth
        self.tittleLbl.text = tittle
    }
    
    @IBAction func dropDownBtnClicked(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: "Choose Your Option", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let option1 = UIAlertAction(title: "School Of Nursing", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            self.presentView(imageName: "HKU_LKS Faculty of Medicine_School of Nursing_Master Logo_Black & Silver... (1).png", logoWidth: 450, tittle: "LKS Faculty of medicine | School of Nursing", typeOfString: "Nursing")
        })
        
        let option2 = UIAlertAction(title: "Faculty of Medicine", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
           
            self.presentView(imageName: "appLogo.png", logoWidth: 200, tittle: "Li Ka Shing Faculty of Medicine", typeOfString: "MBBS")
            
        })
       
        
        optionMenu.addAction(option1)
        optionMenu.addAction(option2)
       
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            if let currentPopoverpresentioncontroller = optionMenu.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = dropDownBtn
                currentPopoverpresentioncontroller.sourceRect = dropDownBtn.bounds;
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up;
                self.present(optionMenu, animated: true, completion: nil)
            }
        }else{
            self.present(optionMenu, animated: true, completion: nil)
        }
        
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
