//
//  Errors.swift
//  ChatSecure
//
//  Created by David Chiles on 9/23/15.
//  Copyright © 2015 Chris Ballinger. All rights reserved.
//

import Foundation

public extension NSError {
    class func XMPPXMLError(error:OTRXMPPXMLError, userInfo:[String:AnyObject]?) -> NSError {
        return self.chatSecureError(error, userInfo: userInfo)
    }
    
    class func chatSecureError(error:ChatSecureErrorProtocol, userInfo:[String:AnyObject]?) -> NSError {
        var tempUserInfo:[String:AnyObject] = [NSLocalizedDescriptionKey:error.localizedDescription()]
        
        if let additionalDictionary = error.additionalUserInfo() {
            additionalDictionary.forEach { tempUserInfo.updateValue($1, forKey: $0) }
        }
        
        //Overwrite out userinfo with provided userinfo dicitonary
        if let additionalDictionary = userInfo {
            additionalDictionary.forEach { tempUserInfo.updateValue($1, forKey: $0) }
        }
        
        return NSError(domain: kOTRErrorDomain, code: error.code(), userInfo: userInfo)
    }
}

public protocol ChatSecureErrorProtocol {
    func code() -> Int
    func localizedDescription() -> String
    func additionalUserInfo() -> [String:AnyObject]?
}

enum PushError: Int {
    case noPushDevice       = 301
    case invalidURL         = 302
    case noBuddyFound       = 303
    case noTokensFound      = 304
    case invalidJSON        = 305
    case missingAPIEndpoint = 306
    case missingTokens      = 307
}

extension PushError {
    func localizedDescription() -> String {
        switch self {
        case .noPushDevice:
            return "No device found. Need to create device first."
        case .invalidURL:
            return "Invalid URL."
        case .noBuddyFound:
            return "No buddy found."
        case .noTokensFound:
            return "No tokens found."
        case .invalidJSON:
            return "Invalid JSON format."
        case .missingAPIEndpoint:
            return "Missing API endpoint key."
        case .missingTokens:
            return "Missing token key"
        }
    }
    
    func error() -> NSError {
        return NSError(domain: kOTRErrorDomain, code: self.rawValue, userInfo: [NSLocalizedDescriptionKey:self.localizedDescription()])
    }
}


@objc public enum OTRXMPPXMLError: Int {
    case UnkownError   = 1000
    case Conflict      = 1001
    case NotAcceptable = 1002
}

extension OTRXMPPXMLError: ChatSecureErrorProtocol {
    public func code() -> Int {
        return self.rawValue
    }
    
    public func localizedDescription() -> String {
        switch self {
        case .UnkownError:
            return "Unknown Error"
        case .Conflict:
            return "There's a conflict with the username"
        case .NotAcceptable:
            return "Not enough information provided"
        }
    }
    
    public func additionalUserInfo() -> [String : AnyObject]? {
        return nil
    }
}