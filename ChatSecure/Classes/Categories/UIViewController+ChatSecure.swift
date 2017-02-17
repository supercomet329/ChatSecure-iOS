//
//  UIViewController+ChatSecure.swift
//  ChatSecure
//
//  Created by Chris Ballinger on 2/16/17.
//  Copyright © 2017 Chris Ballinger. All rights reserved.
//

import UIKit
import OTRAssets

public extension UIViewController {
    /// Will show a prompt to bring user into system settings
    public func showPromptForSystemSettings() {
        let alert = UIAlertController(title: ENABLE_PUSH_IN_SETTINGS_STRING(), message: nil, preferredStyle: .Alert)
        let settingsAction = UIAlertAction(title: SETTINGS_STRING(), style: .Default, handler: { (action: UIAlertAction) -> Void in
            let appSettings = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(appSettings!)
        })
        let cancelAction = UIAlertAction(title: CANCEL_STRING(), style: .Cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    public func showDestructivePrompt(title: String?, buttonTitle: String, handler: ((action: UIAlertAction) -> ())) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .ActionSheet)
        let destroyAction = UIAlertAction(title: buttonTitle, style: .Destructive, handler: handler)
        let cancelAction = UIAlertAction(title: CANCEL_STRING(), style: .Cancel, handler: nil)
        alert.addAction(destroyAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}
