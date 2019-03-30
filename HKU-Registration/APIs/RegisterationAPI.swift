//
//  RegisterationAPI.swift
//  HKU-Registration
//
//  Created by Sachin Indulkar on 30/04/18.
//  Copyright © 2018 Sachin Indulkar. All rights reserved.
//

import UIKit
import Alamofire
open class RegisterationAPI {

    func getTimeStamp() -> String
    {
        return "\(Date().timeIntervalSince1970 * 1000)"
    }
    
    func NDAText(success: @escaping (_ objUser : NDA) -> Void,
               failure: @escaping (Error?)-> Void)
    {
       
        let session = Alamofire.SessionManager.default
        session.session.configuration.urlCache = nil
        
        session.request(RegistrationRouter.getNda()).validate().responseJSON (completionHandler:  { data in
            if(SSError.isErrorReponse(operation: data.response)){
                let error = NSError.init(domain: "Error", code: 422, userInfo: ["message":data.error.debugDescription])//"Please enter data in correct format"
                failure(error)
            }else{
                let dictResponse : NSDictionary? = data.result.value as? NSDictionary
                let status : String? = dictResponse?["status"] as? String
                if(status  == "error"){
                    
                }else{
                    let dictResponse : NSDictionary? = data.result.value as? NSDictionary
                    if dictResponse?.value(forKey: "user") == nil {
                        let objParsed = NDA(dictionary:(dictResponse)!)
                        success (objParsed)
                    }else{
                        let user :NSDictionary  = dictResponse!.value(forKey: "user") as! NSDictionary
                        let objParsed = NDA(dictionary:(user))
                        success (objParsed)
                    }
                }
            }
        })
    }
    
    func login(objUser: User,
               success: @escaping (_ objUser : User) -> Void,
               failure: @escaping (Error?)-> Void)
    {
        let parameters = NSMutableDictionary()
        parameters.setValue(objUser.username, forKey: "username")
        parameters.setValue(objUser.password, forKey: "password")
        parameters.setValue(objUser.device_id, forKey: "device_id")
        parameters.setValue(objUser.token_id, forKey: "token_id")
        
        let session = Alamofire.SessionManager.default
        session.session.configuration.urlCache = nil
        
        session.request(RegistrationRouter.login(parameters: parameters.copy() as! Parameters)).validate().responseJSON (completionHandler:  { data in
            if(SSError.isErrorReponse(operation: data.response)){
//                failure(SSError.errorWithData(data:data))
                let error = NSError.init(domain: "Error", code: 422, userInfo: ["message":data.error.debugDescription])//"Please enter data in correct format"
                failure(error)
            }else{
                let dictResponse : NSDictionary? = data.result.value as? NSDictionary
                let status : String? = dictResponse?["status"] as? String
                if(status  == "error"){
                    
                }else{
                    let dictResponse : NSDictionary? = data.result.value as? NSDictionary
                    if dictResponse?.value(forKey: "user") == nil {
                        let objParsed = User(dictionary:(dictResponse)!)
                        success (objParsed)
                    }else{
                        let user :NSDictionary  = dictResponse!.value(forKey: "user") as! NSDictionary
                        let objParsed = User(dictionary:(user))
                        success (objParsed)
                    }
                }
            }
        })
    }
    
    func getStudentDetail(objStudent: Student,
                          success: @escaping (_ objDetails : DetailWrapper) -> Void,
                          failure: @escaping (Error?)-> Void)
    {
        let parameters = NSMutableDictionary()
        
        
        var jsonObject: [Any]? = nil
        let arr = objStudent.qrcode.components(separatedBy: ",")
        if arr.count>1 {
            if let anEncoding = objStudent.qrcode.data(using: .utf8) {
                jsonObject = try! JSONSerialization.jsonObject(with: anEncoding, options: []) as? [Any]
            }
            parameters.setValue(jsonObject, forKey: "qrcode")
        }
        else{
            parameters.setValue(objStudent.qrcode, forKey: "qrcode")

        }
       
        
        let session = Alamofire.SessionManager.default;
        session.session.configuration.urlCache = nil
        
        session.request(RegistrationRouter.scanQRCode(parameters: parameters.copy() as! Parameters)).validate().responseJSON (completionHandler:  { data in
            if(SSError.isErrorReponse(operation: data.response)){
//                failure(SSError.errorWithData(data:data))
                let error = NSError.init(domain: "Error", code: 422, userInfo: ["message":"Please enter data in correct format"])
                failure(error)
            }else{
                let dictResponse : NSDictionary? = data.result.value as? NSDictionary
                let status : String? = dictResponse?["status"] as? String
                if(status  == "error"){
                    
                }else{
                    let dictResponse : NSDictionary? = data.result.value as? NSDictionary
                    if dictResponse?.value(forKey: "user") == nil {
                        let objParsed = DetailWrapper(dictionary:(dictResponse)!)
                        success (objParsed)
                    }else{
                        let objParsed = DetailWrapper(dictionary:(dictResponse)!)
                        success (objParsed)
                    }
                }
            }
        })
    }
    
    func searchStudentDetail(objStudent: Student,
                          success: @escaping (_ objDetails : DetailWrapper) -> Void,
                          failure: @escaping (Error?)-> Void)
    {
        let parameters = NSMutableDictionary()
        
        if objStudent.qrcode.count>0 {
            parameters.setValue(objStudent.qrcode, forKey: "qrcode")
        }
        
        let session = Alamofire.SessionManager.default;
        session.session.configuration.urlCache = nil
        
        session.request(RegistrationRouter.scanQRCode(parameters: parameters.copy() as! Parameters)).validate().responseJSON (completionHandler:  { data in
            if(SSError.isErrorReponse(operation: data.response)){
//                failure(SSError.errorWithData(data:data))
                let error = NSError.init(domain: "Error", code: 422, userInfo: ["message":"Please enter data in correct format"])
                failure(error)
            }else{
                let dictResponse : NSDictionary? = data.result.value as? NSDictionary
                let status : String? = dictResponse?["status"] as? String
                if(status  == "error"){
                    
                }else{
                    let dictResponse : NSDictionary? = data.result.value as? NSDictionary
                    if dictResponse?.value(forKey: "user") == nil {
                        let objParsed = DetailWrapper(dictionary:(dictResponse)!)
                        success (objParsed)
                    }else{
                        let objParsed = DetailWrapper(dictionary:(dictResponse)!)
                        success (objParsed)
                    }
                }
            }
        })
    }
    
    func uploadStudentImage ( objStudent:Student,
        success: @escaping (_ objDetails : DetailWrapper) -> Void,
        failure: @escaping (Error?)-> Void)
    {
        let parameters = NSMutableDictionary()
        
        if objStudent.id.count>0 {
            parameters.setValue(objStudent.id, forKey: "student_id")
        }
        else{
            parameters.setValue("0", forKey: "student_id")

        }
//        let image = #imageLiteral(resourceName: "sample")
        
        let imageData = UIImagePNGRepresentation(objStudent.image)
        let base64String =  imageData?.base64EncodedString()
        parameters.setValue(base64String, forKey: "pic")
        
        let signatureData = UIImagePNGRepresentation(objStudent.signature)
        let base64Signature =  signatureData?.base64EncodedString()
        parameters.setValue(base64Signature, forKey: "declaration")

        let session = Alamofire.SessionManager.default;
        session.session.configuration.urlCache = nil
        
        session.request(RegistrationRouter.uploadUserImage(parameters: parameters.copy() as! Parameters)).validate().responseJSON (completionHandler:  { data in
            if(SSError.isErrorReponse(operation: data.response)){
//                failure(SSError.errorWithData(data:data))
                let error = NSError.init(domain: "Error", code: 422, userInfo: ["message":"Please enter data in correct format"])
                failure(error)
            }else{
                let dictResponse : NSDictionary? = data.result.value as? NSDictionary
                let status : String? = dictResponse?["status"] as? String
                if(status  == "error")
                {
                }
                else
                {
                    let dictResponse : NSDictionary? = data.result.value as? NSDictionary
                    if dictResponse?.value(forKey: "user") == nil {
                        let objParsed = DetailWrapper(dictionary:(dictResponse)!)
                        success (objParsed)
                    }
                    else{
                        let objParsed = DetailWrapper(dictionary:(dictResponse)!)
                        success (objParsed)
                    }
                }
            }
        })
    }
}
