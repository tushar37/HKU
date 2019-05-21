//
//  ScannerView.swift
//  HKU-Registration
//
//  Created by Sachin Indulkar on 28/04/18.
//  Copyright © 2018 Sachin Indulkar. All rights reserved.
//

import UIKit
import MBProgressHUD
class ScannerView: UIViewController ,QRCodeScannerViewControllerDelegate {
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var tittleLbl: UILabel!
    let nsud = UserDefaults.standard
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var txtEnterCode: UITextField!
    
    @IBOutlet weak var logoImgWidth: NSLayoutConstraint!
    @IBOutlet weak var logoImgHeight: NSLayoutConstraint!
    var objUser : User?
    var strQRCode : String? = ""
    
    func presentView(imageName:String,logoWidth:CGFloat,logoHeight:CGFloat,tittle:String,typeOfString:String)
    {
        self.nsud.set(typeOfString, forKey: "SelectedOption")
        self.logoImgView.image = UIImage(named: imageName)
        self.logoImgWidth.constant = logoWidth
        self.logoImgHeight.constant = logoHeight
        self.tittleLbl.text = tittle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        if UserDefaults.standard.string(forKey: "SelectedOption") == "Nursing"
        {
            self.presentView(imageName: "NursingImageHKU.png", logoWidth: 450, logoHeight: 120, tittle: "LKS Faculty of medicine | School of Nursing", typeOfString: "Nursing")
        }else{
            self.presentView(imageName: "MedicalImageHKU.png", logoWidth: 450, logoHeight: 120, tittle: "Li Ka Shing Faculty of Medicine", typeOfString: "MBBS")
        }
        
    }
    
    func setData() {
        self.lblEventName.text = objUser?.event_name
    }
    
    //MARK :: UIButton action methods
    @IBAction func logoutBtnClick(_ sender: Any) {
        let alert = UIAlertController(title: appTitle,
                                      message: "Are you sure want to logout?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Logout",
                                      style: UIAlertActionStyle.destructive,
                                      handler: {(alert: UIAlertAction!) in
                                        AppManager.saveUserData(objUser: User())
                                        appDel.initControllerBasedOnSession()
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertActionStyle.default,
                                      handler: {(alert: UIAlertAction!) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func scanQRCodeBtnClick(_ sender: Any) {
        let obj  = QRCodeScannerViewController.init(nibName: "QRCodeScannerViewController", bundle: nil)
        obj.delegate = self
        self.present(obj, animated: true) {
        }
        self.txtEnterCode.text = ""
    }
    
    @IBAction func searchBtnClick(_ sender: Any) {
        self.view.endEditing(true)
        if (txtEnterCode.text!.count == 0 && strQRCode?.count == 0){
            appDel.showAlertWith(view: self, title: "Please enter StudentID/Code or scan the QRCode")
            return
        }else{
           self.searchStudentDeatils()
        }
        
    }
    
    
    //MARK: - QRCodeScannerViewControllerDelegate
    func didSuccesfullyFetchedQRCode(qrcode:String){
        if !appDel.isConnectedToNetwork(){
            appDel.showAlertWith(view: self, title: "Please check your internet connection")
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let objStudent = Student()
        RegisterationAPI().getStudentDetail(objStudent: objStudent, success: { (objDetailWrapper) in
            if objDetailWrapper.error == 1 { //Error
                appDel.showAlertWith(view: self, title: objDetailWrapper.message!)
            }else{     //Success
                print("Detail Wrapper \(objDetailWrapper)")
                
                let vc = StudentDetailsView.init(nibName: "StudentDetailsView", bundle: nil)
                vc.objDetail = objDetailWrapper
                vc.qrCode = qrcode
                self.navigationController?.pushViewController(vc, animated: true)
                self.txtEnterCode.text = ""
                self.strQRCode = ""
            }
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }) { (error) in
            appDel.showAlertWith(view: self, title: SSError.getErrorMessage(error))
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
    }
    
    func searchStudentDeatils() {
        if !appDel.isConnectedToNetwork(){
            appDel.showAlertWith(view: self, title: "Please check your internet connection")
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let objStudent = Student()
        objStudent.uid = txtEnterCode.text!
        RegisterationAPI().searchStudentDetail(objStudent: objStudent, success: { (objDetailWrapper) in
            if objDetailWrapper.error == 1 { //Error
                appDel.showAlertWith(view: self, title: objDetailWrapper.message!)
                self.txtEnterCode.text = ""
            }else{     //Success
                print("Detail Wrapper \(objDetailWrapper)")
                
                let vc = StudentDetailsView.init(nibName: "StudentDetailsView", bundle: nil)
                vc.objDetail = objDetailWrapper
                vc.qrCode = self.txtEnterCode.text!
                vc.isSearchBtnClicked = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.txtEnterCode.text = ""
                self.strQRCode = ""
            }
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }) { (error) in
            appDel.showAlertWith(view: self, title: SSError.getErrorMessage(error))
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
    }
}
