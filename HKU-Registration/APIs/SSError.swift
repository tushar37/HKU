//
//  SSError.swift
//  MakeApp
//
//  Created by anand mahajan on 23/07/17.
//  Copyright © 2017 ananadmahajan. All rights reserved.
//

import Foundation
import Alamofire


enum  SSErrorType : Int {
    // API errors
   case Undefined = 0
   case VerifyAccount
   case Unknown
   case BadRequest
   case Unauthorized
   case Forbidden
   case NotFound
   case Conflict
   case EmailPasswordExist
   case UserDoesNotExist
   case ServerError
   case ServerUnavailable
   case AppVersionNotSupported
   case ConnectionCancelled
   case ConnectionError
   case NoNetwork
   case JSONParserError
   case DataModelError
   case RestrictedUser
   case BlacklistedUser
   case LikeBeforeUnlike
   case ContentFilter
   case InvalidFacebookToken
    // AOuth errors
   case OAuthGeneralError
   case UserCredentialsIncorrect
   case InvalidRefreshToken
   case InvalidRequest
   case EmailValidationError

}

enum  SSErrorResolutionType : Int {
    case ShowAlertAndContinue = 1
    case HandleInApp
    case RequestUpgradeAndBlock
    case ForceLogin
}
private let kSSErrorObjectKey: String = "SSErrorObjectKey"

class SSError: NSObject {
    var code: String = ""
    var from: String = ""
    var message: String = ""
    var warning_type: String = ""
    var nserror: Error?
    var operation: HTTPURLResponse?
    var errorType = SSErrorType(rawValue:0)
    var isErrorShown: Bool = false
    
    
     init(message msg: String, code: String, from: String, errorType: SSErrorType) {
        super.init()
        
        self.errorType = errorType
        self.message = msg
        self.code = code
        self.from = from
        isErrorShown = false
        
    }
    
    init(operation: HTTPURLResponse?, error: Error?) {
        super.init()
        
        self.operation = operation
        message = (error?.localizedDescription)!
        nserror = error
        isErrorShown = false
        errorType = errorTypeFromState()
        
    }
   class  func errorWithDic(dict: [AnyHashable: Any]) -> SSError {
         //VVLog(@"JSON: %@, Error: %@", dict, err);
    
    var message = dict["message"]
    if(message==nil)
    {
        message = ""
    }
    
      return  SSError(message:message as! String, code: "", from: "", errorType:SSErrorType.Unknown)
    
    
    }
    
    class func errorWithData(data: DataResponse<Any>) -> Error
    {
        return errorWithData(data: data.data, operation: data.response, error: data.error)
    }
    class func errorWithData(data: Data?, operation: HTTPURLResponse?, error: Error?) -> Error {
        var json = NSDictionary()
        
        if(data != nil && (data?.count)! > 0)
        {
            json = (try!JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary)!
        }
      
        var err: SSError? = errorWithDic(dict: json as! [AnyHashable : Any])
        if err == nil {
            err = errorWithOperation( operation: operation, error: error)
        }
        if err != nil {
            err!.nserror = error
            err!.operation = operation
            err!.errorType = err?.errorTypeFromState()
            err!.isErrorShown = false
        }
        
        var dicUesrInfo = [String: Any]()
        dicUesrInfo[kSSErrorObjectKey] = err;
        
        let nserr = NSError(domain: "", code: 0, userInfo: dicUesrInfo)
       
        return nserr;
    }
    
    class func errorWithDic(dict: [AnyHashable: Any], operation: HTTPURLResponse?, error: Error?) -> SSError {
        var err: SSError? = errorWithDic(dict: dict)
        if err == nil {
           err = errorWithOperation( operation: operation, error: error)
        }
        if err != nil {
            err!.nserror = error
            err!.operation = operation
            err!.errorType = err?.errorTypeFromState()
            err!.isErrorShown = false
        }
        return err!;
    }
    
    class func errorWithOperation(operation: HTTPURLResponse?, error: Error?) -> SSError {
        return SSError(operation: operation, error: error)
    }
    
    func errorWithMediError() -> Error? {
        var tmp = [AnyHashable: Any]()
        tmp[kSSErrorObjectKey] = self
        var newError: Error?
        if (nserror != nil) {
            for (k, v) in (nserror as! NSError).userInfo { tmp.updateValue(v, forKey: k) }
            newError = NSError(domain: (nserror as! NSError).domain, code: (nserror as! NSError).code, userInfo: tmp as! [String : Any])
        }
        else {
            newError = NSError(domain: "", code: 0, userInfo: tmp as! [String : Any])
        }
        return newError
    }
   
    func errorTypeFromState() -> SSErrorType {
        var error : SSErrorType;
       
        if(operation==nil)//in the case of no internet or no response got from server
        {
            return SSErrorType.ConnectionError
        }
        
        switch operation!.statusCode {
        case 400:
            error = .BadRequest;
        case 401:
            error = .Unauthorized;
        case 403:
            error = .Forbidden;
        case 404:
            error = .NotFound;
        case 409:
            error = .Conflict;
        case 500:
            error = .ServerError;
            break;
        case 503:
            error = .ServerUnavailable;
            break;
        case 504:
            error = .ServerUnavailable;
            break;
        default:
            error = .Unknown;
            break;
           
            
        }

        return error;
    }


    
    func errorResolutionType() -> SSErrorResolutionType {
        var resolutionType: SSErrorResolutionType
        switch errorType! {
        case .BadRequest:
            resolutionType = .HandleInApp
        case .Unauthorized:
            resolutionType = .HandleInApp
        case .AppVersionNotSupported:
            resolutionType = .RequestUpgradeAndBlock
        case .Forbidden:
            resolutionType = .HandleInApp
        case .NotFound:
            resolutionType = .HandleInApp
        case .EmailPasswordExist:
            resolutionType = .HandleInApp
        case .UserDoesNotExist:
            resolutionType = .HandleInApp
        case .Conflict:
            resolutionType = .ShowAlertAndContinue
        case .ServerError:
            resolutionType = .ShowAlertAndContinue
        case .ServerUnavailable:
            resolutionType = .ShowAlertAndContinue
        case .ConnectionError:
            resolutionType = .HandleInApp
        case .ConnectionCancelled:
            resolutionType = .HandleInApp
        case .NoNetwork:
            resolutionType = .HandleInApp
        case .JSONParserError:
            resolutionType = .ShowAlertAndContinue
        case .DataModelError:
            resolutionType = .ShowAlertAndContinue
        case .OAuthGeneralError:
            resolutionType = .ForceLogin
        case .UserCredentialsIncorrect:
            resolutionType = .HandleInApp
        case .InvalidRefreshToken:
            resolutionType = .ForceLogin
        case .InvalidRequest:
            resolutionType = .HandleInApp
        case .RestrictedUser:
            resolutionType = .HandleInApp
        case .BlacklistedUser:
            resolutionType = .ShowAlertAndContinue
        case .LikeBeforeUnlike:
            resolutionType = .HandleInApp
        case .ContentFilter:
            resolutionType = .ShowAlertAndContinue
        case .InvalidFacebookToken:
            resolutionType = .HandleInApp
        case .EmailValidationError:
            resolutionType = .ShowAlertAndContinue
        case .VerifyAccount:
            resolutionType = .ShowAlertAndContinue
        default:
            resolutionType = .ShowAlertAndContinue
        }
        
        return resolutionType
    }
    
    //  Converted with Swiftify v1.0.6402 - https://objectivec2swift.com/
    func localizedMessage() -> String {
        var localizedMessage: String
        //if ([self.message isEmpty])
        do {
            //  self.message = NSLocalizedString(@"error_message_generic", nil);
        }
        switch errorType! {
        case .BadRequest:
            localizedMessage = message
        case .VerifyAccount:
            localizedMessage = message
        case .Unauthorized:
            
            if(message.count>0)
            {
              localizedMessage = message
            }
            else
            {
                localizedMessage = NSLocalizedString("error_unauthorized", comment: "")
            }
        case .AppVersionNotSupported:
            localizedMessage = message
        case .Forbidden:
            localizedMessage = message
        case .NotFound:
            localizedMessage = message
        case .EmailPasswordExist:
            localizedMessage = message
        case .UserDoesNotExist:
            localizedMessage = message
        case .Conflict:
            localizedMessage = message
        case .ServerError:
            localizedMessage = NSLocalizedString("error_message_500", comment: "")
        case .ServerUnavailable:
            localizedMessage = NSLocalizedString("error_message_503", comment: "")
        case .ConnectionError:
            localizedMessage = NSLocalizedString("error_message_connection_error", comment: "")
        case .NoNetwork:
            localizedMessage = NSLocalizedString("error_message_no_network", comment: "")
        case .JSONParserError:
            localizedMessage = NSLocalizedString("error_message_500", comment: "")
        case .DataModelError:
            localizedMessage = NSLocalizedString("error_message_500", comment: "")
        case .InvalidRefreshToken:
            localizedMessage = NSLocalizedString("error_message_401", comment: "")
        case .OAuthGeneralError:
            localizedMessage = NSLocalizedString("error_message_500", comment: "")
        case .ContentFilter:
            localizedMessage = NSLocalizedString("error_behind_contentfilter", comment: "")
        case .InvalidFacebookToken:
            localizedMessage = NSLocalizedString("error_invalid_facebook_token", comment: "")
        case .EmailValidationError:
            localizedMessage = NSLocalizedString("invalid_email", comment: "")
        default:
            localizedMessage = message
        }
        
        return localizedMessage
    }

    
    func localizedTitle() -> String {
        return NSLocalizedString("app_name", comment: "")
    }
   
    func debugFullDescription() -> String {
        return "Error: \(nserror!.localizedDescription)\nMessage: \(message)\nCode: \(code)\nFrom: \(from)"
    }
    
    
    func showAlertIfNeeded() {
        if isErrorShown {
            return
        }
        isErrorShown = true
        DispatchQueue.main.async(execute: {() -> Void in
            switch self.errorResolutionType() {
            case .ShowAlertAndContinue:
                self.showNormalAlert()
            default:
                #if DEBUG
                    if self.errorType != .ConnectionCancelled {
                        /*UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Debug info"
                         message:[self debugDescription]
                         delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"ok_capital", nil)
                         otherButtonTitles:nil];
                         [alert show];*/
                    }
                #endif
            }
            
        })
        //VVLog(@"%@", [self debugDescription]);
    }
    
    func showNormalAlert() {
        /*
         #ifdef DEBUG
         NSString* message = [NSString stringWithFormat:@"%@\n\nDebug info\n%@", [self localizedMessage], [self debugDescription]];
         #else
         NSString* message = [self localizedMessage];
         #endif
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[self localizedTitle] message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok_capital", nil) otherButtonTitles:nil];
         [alert show];*/
    }
    
    class func getErrorMessage(_ error: Error?) -> String {
        let nserror =  (error! as NSError).userInfo[kSSErrorObjectKey]
//        let sserror = nserror as! SSError
//
        return  error.debugDescription
          //  return "Please enter data in correct format"
        
    }
    
    class func isErrorReponse(operation: HTTPURLResponse?) -> Bool
    {
        if (operation == nil)
        {
            return true
        }
        else if((operation?.statusCode)!>=300)
        {
           return true
        }
        return false
    
    }
}

