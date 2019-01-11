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
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var Title_Label: UILabel!
    @IBOutlet weak var LogoImage: UIImageView!
    @IBOutlet weak var LogoImgWidth: NSLayoutConstraint!
    @IBOutlet weak var LogoImgHeight: NSLayoutConstraint!
   
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
    func chooseFaculty_Api(Heading: String, imgName: String, selectedVal: String, WidthCons: CGFloat, HeightCons: CGFloat){
        self.Title_Label.text = Heading
        self.LogoImage.image = UIImage(named: imgName)
        self.LogoImgWidth.constant = WidthCons
        self.LogoImgHeight.constant = HeightCons
        UserDefaults.standard.set(selectedVal, forKey: "selected")
    }
    @IBAction func choose_Faculty(_ sender: Any) {
    let optionMenu = UIAlertController(title: "Choose Your Option", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let option1 = UIAlertAction(title: "Nursing", style: .default, handler: {
                
                (alert: UIAlertAction!) -> Void in
                
      self.chooseFaculty_Api(Heading: "LKS Faculty of medicine | School of Nursing", imgName: "HKU_LKS Faculty of Medicine_School of Nursing_Master Logo_Black & Silver... (1)", selectedVal: "Nursing", WidthCons: 450, HeightCons: 180)
            })
            
            let option2 = UIAlertAction(title: "MBBS ", style: .default, handler: {
                
                (alert: UIAlertAction!) -> Void in
                
        self.chooseFaculty_Api(Heading: "Li Ka Shing Faculty of Medicine", imgName: "appLogo", selectedVal: "MBBS", WidthCons: 250, HeightCons: 180)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
            })
            
            optionMenu.addAction(option1)
            optionMenu.addAction(option2)
            optionMenu.addAction(cancelAction)
            
            
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
    
}
