//
//  TwoButtonTableViewCell.swift
//  ChatSecure
//
//  Created by Chris Ballinger on 2/14/17.
//  Copyright © 2017 Chris Ballinger. All rights reserved.
//

import UIKit


@objc(TwoButtonTableViewCell)
public class TwoButtonTableViewCell: UITableViewCell {
    
    public typealias ButtonBlock = (cell: TwoButtonTableViewCell, sender: AnyObject) -> ()

    @IBOutlet public weak var leftButton: UIButton!
    @IBOutlet public weak var rightButton: UIButton!
    
    public var leftAction: ButtonBlock?
    public var rightAction: ButtonBlock?
    
    public class func cellIdentifier() -> String {
        return "TwoButtonTableViewCell"
    }
    
    @IBAction private func leftButtonPressed(sender: AnyObject) {
        guard let block = leftAction else { return }
        block(cell: self, sender: sender)
    }
    
    @IBAction private func rightButtonPressed(sender: AnyObject) {
        guard let block = rightAction else { return }
        block(cell: self, sender: sender)
    }
}
