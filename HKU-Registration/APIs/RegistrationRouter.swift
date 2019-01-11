//
//  RegistrationRouter.swift
//  HKU-Registration
//
//  Created by Sachin Indulkar on 30/04/18.
//  Copyright © 2018 Sachin Indulkar. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

enum RegistrationRouter: URLRequestConvertible{
    var baseComponent: String {
        return ""
    }
    
    case login(parameters:Parameters)
    case scanQRCode(parameters:Parameters)
    case uploadUserImage(parameters:Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
    
        case .scanQRCode:
            return .post
            
        case .uploadUserImage:
            return .post

        }
    }
    
    var path: String {
        switch self
        {
        case .login(_):
            return "/\(baseComponent)login"
       
        case .scanQRCode(_):
            return "/\(baseComponent)scanQRCode"
        case .uploadUserImage(_):
            return "/\(baseComponent)register" //registertest
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url : URL?
        
        if UserDefaults.standard.string(forKey: "SelectedOption") == "Nursing"
        {
             url = try APIConstants.BASE_URL_Nursing.asURL()
        }else{
            url = try APIConstants.BASE_URL_MBBS.asURL()
        }
       
        
        var urlRequest = URLRequest(url: (url?.appendingPathComponent(path))!)
        urlRequest.httpMethod = method.rawValue
        
        
        switch self {
            
        case .login(parameters: let parameters):
            urlRequest.setValue(self.getContentType(type: "JSON"), forHTTPHeaderField: "Content-Type");
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            break
            
        case .scanQRCode(parameters: let parameters):
            urlRequest.setValue(self.getContentType(type: "JSON"), forHTTPHeaderField: "Content-Type");
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            break
            
        case .uploadUserImage(parameters: let parameters):
            urlRequest.setValue(self.getContentType(type: "JSON"), forHTTPHeaderField: "Content-Type");
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            break
            
//        case .getNewsList(parameters: let parameters):
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
//            break
            
        default:
            break
        }
        return urlRequest
        
    }
    
    func getContentType(type : String) -> String {
        
        if(type=="JSON"){
            return "application/json";
        }else{
            return "application/x-www-form-urlencoded; charset=utf-8";
        }
    }
}

