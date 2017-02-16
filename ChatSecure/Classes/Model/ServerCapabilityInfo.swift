//
//  ServerCapabilityInfo.swift
//  ChatSecure
//
//  Created by Chris Ballinger on 2/10/17.
//  Copyright © 2017 Chris Ballinger. All rights reserved.
//

import UIKit

@objc(OTRCapabilityStatus)
public enum CapabilityStatus: UInt {
    case Unknown
    case Available
    case Unavailable
    case Warning
}

public enum CapabilityCode: String {
    case Unknown = "Unknown"
    /// XEP-0198: Stream Management
    case XEP0198 = "XEP-0198"
    /// XEP-0357: Push
    case XEP0357 = "XEP-0357"
}

@objc(OTRServerCapabilityInfo)
public class ServerCapabilityInfo: NSObject, NSCopying {
    public var status: CapabilityStatus = .Unknown
    public let code: CapabilityCode
    public let title: String
    public let subtitle: String
    /// used to match against caps xml
    public let xmlns: String
    public let url: NSURL
    
    public init(code: CapabilityCode, title: String, subtitle: String, xmlns: String, url: NSURL) {
        self.code = code
        self.title = title
        self.subtitle = subtitle
        self.xmlns = xmlns
        self.url = url
    }
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
        return ServerCapabilityInfo(code: self.code, title: self.title, subtitle: self.subtitle, xmlns: self.xmlns, url: url)
    }
    
    public class func allCapabilities() -> [CapabilityCode: ServerCapabilityInfo] {
        var caps: [CapabilityCode: ServerCapabilityInfo] = [:]
        caps[.XEP0198] = ServerCapabilityInfo(
            code: .XEP0198,
            title: "Stream Management",
            subtitle: "XEP-0198: Provides better experience during temporary disconnections.",
            xmlns: "urn:xmpp:sm",
            url: NSURL(string: "https://xmpp.org/extensions/xep-0198.html")!)
        caps[.XEP0357] = ServerCapabilityInfo(
            code: .XEP0357,
            title: "Push",
            subtitle: "XEP-0357: Provides push messaging support.",
            xmlns: "urn:xmpp:push",
            url: NSURL(string: "https://xmpp.org/extensions/xep-0357.html")!)
        return caps
    }
    
    
    
}

public extension OTRServerCapabilities {
    // MARK: Utility

    /**
     * This will determine which features are available.
     * Will return nil if the module hasn't finished processing.
     */
    public func markAvailable(capabilities: [CapabilityCode : ServerCapabilityInfo]) -> [CapabilityCode :ServerCapabilityInfo]? {
        guard let allCaps = self.allCapabilities, let features = self.streamFeatures else {
            return nil
        }
        let allFeatures = OTRServerCapabilities.allFeaturesForCapabilities(allCaps, streamFeatures: features)
        var newCaps: [CapabilityCode : ServerCapabilityInfo] = [:]
        for (_, var capInfo) in capabilities {
            capInfo = capInfo.copy() as! ServerCapabilityInfo
            for feature in allFeatures {
                if feature.containsString(capInfo.xmlns) {
                    capInfo.status = .Available
                    break
                }
            }
            // if its not found, mark it unavailable
            if capInfo.status != .Available {
                capInfo.status = .Unavailable
            }
            newCaps[capInfo.code] = capInfo
        }
        return newCaps
    }
}
