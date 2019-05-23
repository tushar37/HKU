//
//  StudentDetailsView.swift
//  HKU-Registration
//
//  Created by Sachin Indulkar on 29/04/18.
//  Copyright © 2018 Sachin Indulkar. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
import MWPhotoBrowser

class StudentDetailsView: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate,YPSignatureDelegate,UIWebViewDelegate {
    func didStart(_ view: YPDrawSignatureView) {
        print("start drawing")
    }
    @IBOutlet weak var webView: UIWebView!
    
    func didFinish(_ view: YPDrawSignatureView) {
        print("finish drawing")
    }
    
    @IBOutlet weak var mainView: UIView!
    var shouldRotate = ""
    
    @IBOutlet weak var signBox: UIView!
    
    @IBOutlet var drawSignatureInstructionView: UIView!
    @IBOutlet weak var signatureViewWidth: NSLayoutConstraint!
    @IBOutlet weak var btnCameraOREdit: UIButton!
    @IBOutlet weak var imgProfilePick: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblApplicationHash: UILabel!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblGroup: UILabel!
    @IBOutlet weak var lblCircuit: UILabel!
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var btnFullScreen: UIButton!
   
    var objDetail : DetailWrapper?
    var imagePicker = UIImagePickerController()
    var qrCode : String? = ""
    var isSearchBtnClicked : Bool = false
    @IBOutlet weak var viewColor: UIView!
 
    let nsud = UserDefaults.standard
    
    func presentView(tittleForSignatureView:String,typeOfString:String,detailsLbl:String)
    {
        self.nsud.set(typeOfString, forKey: "SelectedOption")
      }
    
    func signatureButtonView(btn:UIButton,color:UIColor,alpha:CGFloat)
    {
        btn.layer.cornerRadius = 5
        btn.backgroundColor = color
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.alpha = alpha
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        signatureArea.delegate = self
        self.viewBox.layer.borderWidth = 1.0
        self.viewBox.layer.borderColor = UIColor.gray.cgColor
        self.viewBox.clipsToBounds = true
        self.setData()
        if UserDefaults.standard.string(forKey: "SelectedOption") == "Nursing"
        {
           
            self.presentView(tittleForSignatureView: "THE UNIVERSITY OF HONG KONG LKS Faculty of medicine | School of Nursing", typeOfString: "Nursing", detailsLbl: "              I, undersigned, am a candidate for the Bachelor of Nursing (FT) programme at the University of Hong Kong and a participant in the Multiple Mini Interview (MMI). I hereby undertake to maintain full confidentiality of all information relative to the content of the stations and interview questions.")
            
           // self.presentView(imageName: "HKU_LKS Faculty of Medicine_School of Nursing_Master Logo_Black & Silver... (1).png", logoWidth: 450, tittle: "LKS Faculty of medicine | School of Nursing", typeOfString: "Nursing")
        }else{
            self.presentView(tittleForSignatureView: "THE UNIVERSITY OF HONG KONG LKS Faculty of medicine | School of Nursing", typeOfString: "MBBS", detailsLbl: "              I, undersigned, am a candidate for the Bachelor of Medicine and Bachelor of Surgery (MBBS) programme at the University of Hong Kong and a participant in the Multiple Mini Interview (MMI). I hereby undertake to maintain full confidentiality of all information relative to the content of the stations and interview questions.")
            //self.presentView(imageName: "MedicalImageHKU.png", logoWidth: 250, tittle: "Li Ka Shing Faculty of Medicine", typeOfString: "MBBS")
        }
       
    }
    @objc func rotated() {
     if shouldRotate == "YES"
     {
        blackBackgroundView.removeFromSuperview()
        signatureView.removeFromSuperview()
         }
    }

    func checkProfileImage()
    {
        if (self.objDetail?.student?.registered)! {
            self.lblStatus.textColor = UIColor.green
            self.lblStatus.text="Registered"
         }else{
            self.lblStatus.textColor = UIColor.red
            self.lblStatus.text="Un Registered"
          }
     }

    func base64Convert(base64String: String?) -> UIImage{
        var image = #imageLiteral(resourceName: "signature")
        if (base64String?.isEmpty)! {
            return #imageLiteral(resourceName: "signature")
        }else {
            //https://freakycoder.com/ios-notes-25-how-to-convert-base64string-to-uiimage-cacec2117603
            if let baseString = base64String {
                let dataDecoded:Data = NSData(base64Encoded: baseString, options: NSData.Base64DecodingOptions(rawValue: 0))! as Data
                if let img = UIImage(data: dataDecoded) {
                    image = img
                }
              }
            
            return image
        }
    }
    func setData(){
        
        self.lblFullName.text = (self.objDetail?.student?.first_name)! + " " + (self.objDetail?.student?.last_name)!
       self.lblCode.text =  self.objDetail?.student?.uid
        if let stationNumber = self.objDetail?.student?.station_no {
            self.lblApplicationHash.text = stationNumber
        }
        if let order = self.objDetail?.student?.order {
            self.lblID.text = order
        }
   
        DispatchQueue.main.async {
            self.imgProfilePick.sd_setImage(with: URL(string: (self.objDetail?.student?.pic)!), placeholderImage: UIImage(named: "profileImage.png"))
         }
        self.checkProfileImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
         })
        
    }
    
    func changeDesign() {
        if (self.objDetail?.student?.pic.count)! > 0 {
            self.btnFullScreen.alpha = 1.0
            self.btnCameraOREdit.setImage(UIImage.init(named: "editPhoto"), for: .normal)
        }
        else{
            self.btnFullScreen.alpha = 0.0
            self.btnCameraOREdit.setImage(UIImage.init(named: "camera"), for: .normal)
        }

    }
    
    //MARK :: UIButton action methods
    @IBAction func cameraOReditBtnClick(_ sender: Any) {
        self.openCamera()
    }
    
    @IBAction func fullImageBtnClick(_ sender: Any) {
        let photoBrowser = MWPhotoBrowser.init()
        photoBrowser.delegate = self
        photoBrowser.displayActionButton = true
        photoBrowser.displayNavArrows = false
        photoBrowser.displaySelectionButtons = false
        photoBrowser.zoomPhotosToFill = false
        photoBrowser.alwaysShowControls = false
        self.navigationController?.pushViewController(photoBrowser, animated: true)
    }
    
    //MARK: MWPhotoBrowserDelegate
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return 1
    }
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if let imgUrl = URL.init(string:(self.objDetail?.student?.pic)!){
            let objMWPhoto = MWPhoto(url: imgUrl)
            return objMWPhoto
        }
        
        return nil
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK :: Open camera function
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                self.doOtherStuff()
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        self.doOtherStuff()
                    } else {
                        let alert = UIAlertController(title: appTitle,
                                                      message: "Camera access is denied, please go to settings & enable camera privacy",
                                                      preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Settings",
                                                      style: UIAlertActionStyle.default,
                                                      handler: {(alert: UIAlertAction!) in
                                                        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                                                            return
                                                        }
                                                        
                                                        if UIApplication.shared.canOpenURL(settingsUrl) {
                                                            if #available(iOS 10.0, *) {
                                                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                                                    print("Settings opened: \(success)") // Prints true
                                                                })
                                                            } else {
                                                                UIApplication.shared.openURL(settingsUrl)
                                                            }
                                                        }
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel",
                                                      style: UIAlertActionStyle.destructive,
                                                      handler: {(alert: UIAlertAction!) in }))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func doOtherStuff(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func reloadInfo() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let objStudent = Student()
        RegisterationAPI().getStudentDetail(objStudent: objStudent, success: { (objDetailWrapper) in
            if objDetailWrapper.error == 1 { //Error
                appDel.showAlertWith(view: self, title: objDetailWrapper.message!)
            }else{     //Success
                print("Detail Wrapper \(objDetailWrapper)")
                self.objDetail = objDetailWrapper
                self.setData()
            }
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }) { (error) in
            appDel.showAlertWith(view: self, title: SSError.getErrorMessage(error))
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
    }
    
    func callRegisterAPI()
    {
          RegisterationAPI().uploadStudentImage(objStudent: (self.objDetail?.student)!, success: { (objCommon) in
                self.reloadStudentDetails()
            }) { (error) in
                appDel.showAlertWith(view: self, title: SSError.getErrorMessage(error))
            }
        
    }
    
    //MARK :: UIImagePicker delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgProfilePick.image = appDel.scaleAndRotateImage(image: pickedImage, angle: 0, flipVertical: 0, flipHorizontal: 0, targetSize: CGSize(width: 300, height: 300))
           objDetail?.student?.image = self.imgProfilePick.image!
            self.callRegisterAPI()
         }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK :: New functionality Digital Signature
    @IBOutlet weak var testView: UIView!
    
    @IBOutlet var signatureView: UIView!
    @IBOutlet weak var signatureArea: YPDrawSignatureView!
     let blackBackgroundView = UIView()
    let upperLayerBlackView = UIView()
    
    func addSubViewMethod(view:UIView)
    {
        upperLayerBlackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        upperLayerBlackView.backgroundColor = UIColor.black
        signatureView.window?.addSubview(upperLayerBlackView)
        upperLayerBlackView.alpha = 0.5
        view.center = upperLayerBlackView.center
        view.layer.cornerRadius = 10
        upperLayerBlackView.window?.addSubview(view)
       
    }
    
    func addSinatureMethod()
    {
        MBProgressHUD.showAdded(to: self.webView, animated: true)
         RegisterationAPI().NDAText(success: { (objUserResult) in
                   if objUserResult.error == 1 { //Error
                      appDel.showAlertWith(view: self, title: objUserResult.message!)
                   }
                 else{     //Success
                    self.webView.loadHTMLString((objUserResult as AnyObject).value(forKey: "student_nda") as! String, baseURL: nil)
                    
                }
                })  { (error) in
                    appDel.showAlertWith(view: self, title: SSError.getErrorMessage(error))
         }
        blackBackgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        blackBackgroundView.backgroundColor = UIColor.black
        self.view.addSubview(blackBackgroundView)
        blackBackgroundView.alpha = 0.5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBlackView))
        tapGesture.numberOfTapsRequired = 1
        blackBackgroundView.addGestureRecognizer(tapGesture)
        blackBackgroundView.window?.addSubview(signatureView)
        signatureView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 600)
        signatureArea.layer.cornerRadius = 10
        signatureArea.layer.borderWidth = 1.0
        signatureArea.layer.borderColor = UIColor.gray.cgColor
        signatureView.center = self.view.center
        signatureView.layer.cornerRadius = 10
     }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print(UIDevice.current.orientation.isLandscape)
    }
    @IBAction func addSignatureClicked(_ sender: UIButton) {
        shouldRotate = "YES"
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
       MBProgressHUD.hideAllHUDs(for: self.webView, animated: true)
        
    }

    @IBAction func okClicked(_ sender: UIButton) {
         upperLayerBlackView.removeFromSuperview()
         drawSignatureInstructionView.removeFromSuperview()
    }
    @IBAction func clearClicked(_ sender: UIButton) {
        signatureArea.clear()
    }
    @objc func tapOnBlackView(){
        shouldRotate = "NO"
        blackBackgroundView.removeFromSuperview()
        signatureView.removeFromSuperview()
    }
    
    //MARK :: Reload student details when uploaded profile image successfully
    func reloadStudentDetails() {
        if !appDel.isConnectedToNetwork(){
            appDel.showAlertWith(view: self, title: "Please check your internet connection")
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let objStudent = self.objDetail?.student
        
        if self.isSearchBtnClicked {
            RegisterationAPI().searchStudentDetail(objStudent: objStudent!, success: { (objDetailWrapper) in
                if objDetailWrapper.error == 1 { //Error
                    appDel.showAlertWith(view: self, title: objDetailWrapper.message!)
                }else{     //Success
                    print("Detail Wrapper \(objDetailWrapper)")
                    self.objDetail = objDetailWrapper
                    self.setData()
                }
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }) { (error) in
                appDel.showAlertWith(view: self, title: SSError.getErrorMessage(error))
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
        }else{
            RegisterationAPI().getStudentDetail(objStudent: objStudent!, success: { (objDetailWrapper) in
                if objDetailWrapper.error == 1 { //Error
                    appDel.showAlertWith(view: self, title: objDetailWrapper.message!)
                }else{     //Success
                    print("Detail Wrapper \(objDetailWrapper)")
                    self.objDetail = objDetailWrapper
                    self.setData()
                }
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }) { (error) in
                appDel.showAlertWith(view: self, title: SSError.getErrorMessage(error))
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
        }
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
extension UIViewController{
    func showAlertTitleMessageOnMainThread(_ titleHead: String, message: String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: titleHead, message: message, preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
