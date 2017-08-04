//
//  OTRRoomOccupantsViewController.swift
//  ChatSecure
//
//  Created by David Chiles on 10/28/15.
//  Copyright © 2015 Chris Ballinger. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

open class OTRRoomOccupantsViewController: UIViewController {
    
    @IBOutlet open weak var tableView:UITableView!
    @IBOutlet weak var largeAvatarView:UIImageView!
    
    open var viewHandler:OTRYapViewHandler?
    open var roomKey:String?
    open var room:OTRXMPPRoom?
    open var headerRows:[String] = []
    open var footerRows:[String] = []
    static let CellIdentifier = "Cell"
    
    public init(databaseConnection:YapDatabaseConnection, roomKey:String) {
        super.init(nibName: nil, bundle: nil)
        setupViewHandler(databaseConnection: databaseConnection, roomKey: roomKey)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func setupViewHandler(databaseConnection:YapDatabaseConnection, roomKey:String) {
        self.roomKey = roomKey
        databaseConnection.read({ (transaction) in
            if let key = self.roomKey {
                self.room = OTRXMPPRoom.fetchObject(withUniqueID: key, transaction: transaction)
            }
        })
        viewHandler = OTRYapViewHandler(databaseConnection: databaseConnection)
        if let viewHandler = self.viewHandler, let roomKey = self.roomKey {
            viewHandler.delegate = self
            viewHandler.setup(DatabaseExtensionName.groupOccupantsViewName.name(), groups: [roomKey])
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerRows.append("name")
        self.headerRows.append("share")
        self.headerRows.append("addFriends")
        self.headerRows.append("mute")
        self.headerRows.append("members")
        self.footerRows.append("leave")
        
        let image = OTRGroupAvatarGenerator.avatarImage(withUniqueIdentifier: self.roomKey!, width: Int(largeAvatarView.frame.width), height: Int(largeAvatarView.frame.height))
        largeAvatarView.image = image

        //Setup Table View
        if (self.tableView == nil) {
            self.tableView = UITableView(frame: CGRect.zero, style: .plain)
            self.view.addSubview(self.tableView)
            self.tableView.autoPinEdgesToSuperviewEdges()
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(OTRBuddyInfoCell.self, forCellReuseIdentifier: OTRRoomOccupantsViewController.CellIdentifier)
    }
    
    open func createHeaderCell(indexPath:IndexPath, type:String) -> UITableViewCell {
        switch type {
        case "name":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellGroupName", for: indexPath)
            if let key = self.roomKey {
                OTRDatabaseManager.shared.readOnlyDatabaseConnection?.read({ (transaction) in
                    if let room = OTRXMPPRoom.fetchObject(withUniqueID: key, transaction: transaction) {
                        cell.textLabel?.text = room.subject
                        cell.detailTextLabel?.text = "" // Do we have creation date?
                    }
                })
            }
            cell.selectionStyle = .none
            return cell
        case "share":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellGroupShare", for: indexPath)
            return cell
        case "addFriends":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellGroupAddFriends", for: indexPath)
            return cell
        case "mute":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellGroupMute", for: indexPath)
            return cell
        case "members":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellGroupMembers", for: indexPath)
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    open func createFooterCell(indexPath:IndexPath, type:String) -> UITableViewCell {
        switch type {
        case "leave":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellGroupLeave", for: indexPath)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    open func didSelectHeaderCell(indexPath:IndexPath, type:String) {
        print("Selected \(type)")
    }
    
    open func didSelectFooterCell(indexPath:IndexPath, type:String) {
        print("Selected \(type)")
    }
    
    open func heightForHeaderCell(indexPath:IndexPath, type:String) -> CGFloat {
        return 44
    }
    
    open func heightForFooterCell(indexPath:IndexPath, type:String) -> CGFloat {
        return 44
    }
}

extension OTRRoomOccupantsViewController: OTRYapViewHandlerDelegateProtocol {

    public func didSetupMappings(_ handler: OTRYapViewHandler) {
        self.tableView?.reloadData()
    }
    
    public func didReceiveChanges(_ handler: OTRYapViewHandler, sectionChanges: [YapDatabaseViewSectionChange], rowChanges: [YapDatabaseViewRowChange]) {
        //TODO: pretty animations
        self.tableView?.reloadData()
    }
}

extension OTRRoomOccupantsViewController: UITableViewDataSource {
    //Int and UInt issue https://github.com/yapstudios/YapDatabase/issues/116
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = self.viewHandler?.mappings?.numberOfSections() {
            return 2 + Int(sections)
        }
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHeaderSection(section: section) {
            return headerRows.count
        } else if isFooterSection(section: section) {
            return footerRows.count
        }
        if let rows = self.viewHandler?.mappings?.numberOfItems(inSection: UInt(section - 1)) {
            return Int(rows)
        }
        return 0
    }
    
    open func isHeaderSection(section:Int) -> Bool {
        return section == 0
    }
    
    open func isFooterSection(section:Int) -> Bool {
        if let sections = self.viewHandler?.mappings?.numberOfSections() {
            if (section == (Int(sections) + 1)) {
                return true
            }
            return false
        }
        return section == 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isHeaderSection(section: indexPath.section) {
            return createHeaderCell(indexPath: indexPath, type: headerRows[indexPath.row])
        } else if isFooterSection(section: indexPath.section) {
            return createFooterCell(indexPath: indexPath, type: footerRows[indexPath.row])
        }
        let adjustedIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
        let cell:OTRBuddyInfoCell = tableView.dequeueReusableCell(withIdentifier: OTRRoomOccupantsViewController.CellIdentifier, for: indexPath) as! OTRBuddyInfoCell
        var buddy:OTRXMPPBuddy? = nil
        if let roomOccupant = self.viewHandler?.object(adjustedIndexPath) as? OTRXMPPRoomOccupant, let room = self.room {
            OTRDatabaseManager.shared.readOnlyDatabaseConnection?.read({ (transaction) in
                    buddy = OTRXMPPBuddy.fetch(withUsername: roomOccupant.realJID ?? roomOccupant.jid!, withAccountUniqueId: room.accountUniqueId!, transaction: transaction)
            })
            if let buddy = buddy {
                cell.setThread(buddy, account: nil)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension OTRRoomOccupantsViewController:UITableViewDelegate {
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if isHeaderSection(section: indexPath.section) {
            return heightForHeaderCell(indexPath:indexPath, type:headerRows[indexPath.row])
        } else if isFooterSection(section: indexPath.section) {
            return heightForFooterCell(indexPath:indexPath, type:footerRows[indexPath.row])
        }
        return 80.0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isHeaderSection(section: indexPath.section) {
            return heightForHeaderCell(indexPath:indexPath, type:headerRows[indexPath.row])
        } else if isFooterSection(section: indexPath.section) {
            return heightForFooterCell(indexPath:indexPath, type:footerRows[indexPath.row])
        }
        return 80.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isHeaderSection(section: indexPath.section) {
            didSelectHeaderCell(indexPath:indexPath, type:headerRows[indexPath.row])
        } else if isFooterSection(section: indexPath.section) {
            didSelectFooterCell(indexPath:indexPath, type:footerRows[indexPath.row])
        }
    }
    
}
